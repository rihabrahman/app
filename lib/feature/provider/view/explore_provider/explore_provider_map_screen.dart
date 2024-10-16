import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/controller/explore_provider_controller.dart';
import 'package:demandium/feature/provider/widgets/explore_provider_item_view.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ExploreProviderMapScreen extends StatefulWidget {
  const ExploreProviderMapScreen({super.key});

  @override
  State<ExploreProviderMapScreen> createState() => _ExploreProviderMapScreenState();
}

class _ExploreProviderMapScreenState extends State<ExploreProviderMapScreen> {

  GoogleMapController? _mapController;
  LatLng? _initialPosition;


  @override
  void initState() {
    super.initState();

    Get.find<ExploreProviderController>().getProviderList(1, false);
    Get.find<ExploreProviderController>().resetSelectedProviderIndex();


    _initialPosition = LatLng(
      double.tryParse(Get.find<LocationController>().getUserAddress()?.latitude ?? "23.0000") ?? 23.0000,
      double.tryParse(Get.find<LocationController>().getUserAddress()?.longitude ?? "90.0000") ?? 90.0000,
    );

    Get.find<ExploreProviderController>().scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "nearby_provider".tr, onBackPressed: (){
        if(Navigator.canPop(context)){
          Get.back();
        }else{
          Get.offAllNamed(RouteHelper.getMainRoute("home"));
        }
      },),
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      body: GetBuilder<ExploreProviderController>(builder: (exploreProviderController){
        return  FooterBaseView(
          isScrollView: ResponsiveHelper.isDesktop(context),
          child: SizedBox(
            height: ResponsiveHelper.isDesktop(context) ? Get.height * 0.8 : Get.height,
            child: Center(
              child: WebShadowWrap(
                child: exploreProviderController.providerList == null ? const Center(child: CircularProgressIndicator()) : Row(
                  children: [

                    ResponsiveHelper.isDesktop(context) ? Expanded(
                      child: Column( children: [

                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                             IconButton(onPressed: (){
                               if(Navigator.canPop(context)){
                                 Get.back();
                               }else{
                                 Get.toNamed(RouteHelper.getMainRoute("home"));
                               }
                             }, icon:  Icon(Icons.arrow_back_ios_new_outlined,color: Theme.of(context).textTheme.bodyLarge?.color!.withOpacity(0.7))),
                            Text("nearby_provider".tr, style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color!.withOpacity(0.7)
                            ),),
                            const SizedBox()
                          ],),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                        Expanded(
                          child: ListView.builder(
                            itemCount: exploreProviderController.providerList?.length,
                            controller: exploreProviderController.scrollController,
                            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                            itemBuilder: (context,index){
                              return Padding(
                                padding:  EdgeInsets.only(
                                  right: Get.find<LocalizationController>().isLtr ?  Dimensions.paddingSizeDefault : 0,
                                  left: Get.find<LocalizationController>().isLtr ?  0 : Dimensions.paddingSizeDefault,
                                ),
                                child: AutoScrollTag(
                                  controller:  exploreProviderController.scrollController!,
                                  key: ValueKey(index),
                                  index: index,
                                  child: ExploreProviderItemView(
                                    providerData: exploreProviderController.providerList![index],
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            shrinkWrap: true,
                          ),
                        ),
                      ],
                    ), ) : const SizedBox(),

                   ResponsiveHelper.isDesktop(context) ? const SizedBox(width: Dimensions.paddingSizeSmall,) : const SizedBox(),

                    Expanded( flex: 2,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 0),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(target: _initialPosition!, zoom: 16),
                              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                              onMapCreated: (GoogleMapController mapController) async  {
                                _mapController = mapController;
                                exploreProviderController.setMarker(mapController, _initialPosition!);

                              },
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              myLocationEnabled: true,
                              markers: exploreProviderController.markers,
                              style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,

                            ),
                          ),

                          GetBuilder<LocationController>(builder: (locationController){

                            return Positioned(
                              top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                              child: InkWell(
                                onTap: () => Get.dialog(
                                  Center(
                                    child: Padding(padding: EdgeInsets.only(
                                      top: ResponsiveHelper.isDesktop(context) ? 0 : 80,
                                      left: ResponsiveHelper.isDesktop(context)? Dimensions.webMaxWidth * 0.35 : 0),
                                      child: SizedBox(
                                        width: ResponsiveHelper.isDesktop(context) ?  Dimensions.webMaxWidth * 0.65 : Dimensions.webMaxWidth,
                                        child: LocationSearchDialog(mapController: _mapController!),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                  child: Row(children: [
                                    Icon(Icons.location_on, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6)),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Expanded(
                                      child: Text(locationController.pickAddress.address ?? "",
                                        style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                    Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                                  ]),
                                ),
                              ),
                            );
                          }),

                          Positioned(
                            bottom: ResponsiveHelper.isDesktop(context)? 20 : 180, right: Dimensions.paddingSizeSmall,
                            child: FloatingActionButton(
                              hoverColor: Colors.transparent,
                              mini: true, backgroundColor:Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                exploreProviderController.getCurrentLocation(mapController :_mapController!, defaultLatLng: _initialPosition);
                              },
                              child: Icon(Icons.my_location,
                                  color: Colors.white.withOpacity(0.9)
                              ),
                            ),
                          ),

                          !ResponsiveHelper.isDesktop(context) ? Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 170,
                              child: SingleChildScrollView(
                                controller: exploreProviderController.scrollController,
                                scrollDirection: Axis.horizontal,
                                child: Row(children: exploreProviderController.providerList!.map((provider) => SizedBox(
                                  width: 350,
                                  child: InkWell(
                                    onTap: () async {
                                      await exploreProviderController.scrollController!.scrollToIndex(exploreProviderController.providerList!.indexOf(provider),
                                          preferPosition: AutoScrollPosition.middle);
                                      await  exploreProviderController.scrollController!.highlight(exploreProviderController.providerList!.indexOf(provider));
                                    },
                                    child: AutoScrollTag(
                                      controller:  exploreProviderController.scrollController!,
                                      key: ValueKey(exploreProviderController.providerList!.indexOf(provider)),
                                      index: exploreProviderController.providerList!.indexOf(provider),
                                      child: ExploreProviderItemView(
                                        providerData: provider,
                                        index: exploreProviderController.providerList!.indexOf(provider),
                                      ),
                                    ),
                                  ),
                                )).toList()),
                              ),
                            ),
                          ) : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
