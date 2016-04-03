module SourceFilesBaseTest
    extend ActiveSupport::Concern

    included do
        setup :activate_authlogic
        
        test "should get index" do
            UserSession.create users(:jolly)
            get_json :index, path_params(fixture)
            assert_response :success
        end
    
        test "should get source_file" do
            UserSession.create users(:jolly)
            get_json :show, path_params(fixture)
            assert_response :success
        end
        
        test "should respond with :not_found for non existing source_file" do
            UserSession.create users(:jolly)
            get_json :show, path_params(SourceFile.new :id => 1, :source_set => fixture.exercise)
            assert_response :not_found
        end
    
        test "should respond with :not_found for non existing source_set" do
            p = {'id' => fixture.id}
            p[fixture.source_set_type.downcase + "_id"] = 1
            get_json :show, p
        end
            
        test "should create source_file" do
            sf = select_fields(fixture, SourceFilesBaseController::MODIFIABLE)
            sf["name"] = "new_name"
            
            UserSession.create manager
            post_json :create, path_params(fixture), sf
            assert_response :success
            assert_equal sf["name"], assigns(:source_file).name
        end
        
        test "should update source_file" do
          sf = select_fields(fixture, SourceFilesBaseController::MODIFIABLE)
          sf["name"] = "NameChange"
          
          UserSession.create manager
          put_json :update, path_params(fixture), sf
          assert_response :success
          assert_equal sf["name"], assigns(:source_file).name
        end
        
        test "should destroy source_file" do
            UserSession.create manager
            delete :destroy, path_params(fixture)
            assert_response :no_content
        end
        
        test "should not allow create file with duplicate name" do
          sf = select_fields(fixture, SourceFilesBaseController::MODIFIABLE)
          sf["contents"] = "new contents"
          
          UserSession.create manager
          post_json :create, path_params(fixture), sf
          assert_response :conflict
        end

        test "should not allow update file with duplicate name" do
          sf = select_fields(fixture, SourceFilesBaseController::MODIFIABLE)
          sf["name"] = "OtherFile"
          
          # Create file that we will attempt to update fixture name to afterwards
          UserSession.create manager
          post_json :create, path_params(fixture), sf

          # Update fixture to same name
          put_json :update, path_params(fixture), sf
          assert_response :conflict                    
        end
    end
end
