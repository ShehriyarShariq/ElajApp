class BasicDoctor {
  String id, categoryId, name, specialty, photoURL, gender;
  num rating, expYears, rate;

  BasicDoctor.empty();

  BasicDoctor(
      {this.id,
      this.categoryId,
      this.name,
      this.photoURL,
      this.gender,
      this.specialty,
      this.expYears,
      this.rating,
      this.rate});
}
