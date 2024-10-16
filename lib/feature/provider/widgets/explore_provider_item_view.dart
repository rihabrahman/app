import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/favorite_icon_widget.dart';
import 'package:demandium/components/on_hover.dart';
import 'package:demandium/components/ripple_button.dart';
import 'package:demandium/feature/provider/controller/explore_provider_controller.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';

class ExploreProviderItemView extends StatelessWidget {
  final ProviderData providerData;
  final int index;
  const ExploreProviderItemView({super.key,  required this.providerData, required this.index}) ;

  @override
  Widget build(BuildContext context) {

    List<String> subcategory=[];
    providerData.subscribedServices?.forEach((element) {
      if(element.subCategory!=null){
        subcategory.add(element.subCategory?.name??"");
      }
    });

    String subcategories = subcategory.toString().replaceAll('[', '');
    subcategories = subcategories.replaceAll(']', '');
    subcategories = subcategories.replaceAll('&', ' and ');

    return GetBuilder<ExploreProviderController>(builder: (exploreProviderController){
      return Padding(padding: const EdgeInsets.all(5.0),
        child: OnHover(
          isItem: true,
          borderRadius: 15,
          child: Stack(
            children: [

              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(
                    color: exploreProviderController.selectedProviderIndex == index ?
                    Theme.of(context).colorScheme.primary.withOpacity(0.5) : Theme.of(context).hintColor.withOpacity(0.15),
                  ),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row( crossAxisAlignment: CrossAxisAlignment.start ,children: [

                    ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                      child: CustomImage(height: 60, width: 60, fit: BoxFit.cover,
                        image: "${Get.find<SplashController>().configModel.content?.imageBaseUrl}/provider/logo/${providerData.logo}",
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text(providerData.companyName??"", style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),

                        Padding(padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(children: [
                            RatingBar(rating: providerData.avgRating, size: 15,),
                            Gaps.horizontalGapOf(5),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child:  Text('${providerData.ratingCount} ${'reviews'.tr}', style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).secondaryHeaderColor,
                              )),
                            ),
                          ],
                          ),
                        ),

                        Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Row(children: [
                            Image.asset(Images.iconLocation, height:12),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Flexible(
                                child: Text("${providerData.distance!.toStringAsFixed(2)} ${'km_away_from_you'.tr}",
                                  style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.primary ,fontSize: Dimensions.fontSizeSmall),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                          ],),
                        )
                      ],),
                    ),


                  ],),

                  const SizedBox(height: Dimensions.paddingSizeSmall,),

                  Row(children: [
                    Expanded(child: ProviderInfoButton(title: "${providerData.subscribedServicesCount}", subtitle: "services".tr,)),
                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                    Expanded(child: ProviderInfoButton(title: "${providerData.totalServiceServed}", subtitle: "services_provided".tr,)),

                  ],)

                ]),
              ),
              Positioned.fill(child: RippleButton(onTap: () {
                Get.toNamed(RouteHelper.getProviderDetails(providerData.id!,subcategories));
              }, borderRadius: 15,),),

              Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(value: providerData.isFavorite, onTap: () async {
                  if(Get.find<AuthController>().isLoggedIn()){
                    exploreProviderController.updateIsFavoriteStatus(providerId: providerData.id!, index: index);
                  }else{
                    customSnackBar("please_login_to_add_favorite_list".tr);
                  }
                },),
              ),
            ],
          ),
        ),
      );
    });
  }
}





class ProviderInfoButton extends StatelessWidget {
  final String? title;
  final String subtitle;
  const ProviderInfoButton({super.key, this.title, required this.subtitle}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).hintColor.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall -1 ),

      child: Column(children: [
        Text("$title", style: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),),
        Text(subtitle, style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: Dimensions.fontSizeSmall)),
        const SizedBox(height: 3,)
      ],),
    );
  }
}

