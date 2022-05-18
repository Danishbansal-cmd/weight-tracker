class OnboradingValues {
  String? title;
  String? subTitle;
  String? imgPath;
  String? description;
  int? index;

  OnboradingValues(
      {this.title, this.subTitle, this.imgPath, this.description, this.index});
}

List<OnboradingValues> onboradingValues = [
  OnboradingValues(
    title: 'Track Your Weight',
    subTitle: 'On Daily Basis',
    imgPath: 'assets/onboarding_images/onboarding_page_png1.png',
    description:
        '''Lorem Ipsum is simply dummy text of the printing andtypesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.''',
    index: 1,
  ),
  OnboradingValues(
    title: 'Personalize Your Data',
    subTitle: 'Access Everywhere',
    imgPath: 'assets/onboarding_images/onboarding_page_png2.png',
    description:
        '''Lorem Ipsum is simply dummy text of the printing andtypesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.''',
    index: 2,
  ),
  OnboradingValues(
    title: 'Set Your Goal',
    subTitle: 'And Start Your Journey',
    imgPath: 'assets/onboarding_images/onboarding_page_png3.png',
    description:
        '''Lorem Ipsum is simply dummy text of the printing andtypesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.''',
    index: 3,
  ),
];
