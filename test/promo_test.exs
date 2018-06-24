defmodule PromoTest do
  use ExUnit.Case
  doctest Promo

  test "Generate random list of codes by group_id" do
    Promo.generate(%{:count => 11, :group_id => 1})
    Promo.generate(%{:count => 22, :group_id => 22})
    Promo.generate(%{:count => 33, :group_id => 333})
  end

  test "Generate custom list of codes by group_id" do
    Promo.generate(%{:custom => "TEST_CODE_ALFA_1", :group_id => 1})
    Promo.generate(%{:custom => "TEST_CODE_BETA_1", :group_id => 22})
    Promo.generate(%{:custom => "TEST_CODE_RELEASE_1", :group_id => 333})
  end

  test "Check custom codes" do
    Promo.check_code("TEST_CODE_ALFA_1")
    Promo.check_code("TEST_CODE_BETA_1")
    Promo.check_code("TEST_CODE_RELEASE_1")
  end
end
