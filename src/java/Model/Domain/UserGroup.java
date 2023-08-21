package Model.Domain;

import java.io.Serializable;

public class UserGroup implements Serializable {

    private String userGroupID;
    private String userGroupName;
    private String userGroupDesc;
    private String accessRights;


    public UserGroup() {
    }
    
    public UserGroup(String userGroupID) {
        this.userGroupID = userGroupID;
    }

    public UserGroup(String userGroupName, String userGroupDesc, String accessRights) {
        this();
        this.userGroupName = userGroupName;
        this.userGroupDesc = userGroupDesc;
        this.accessRights = accessRights;
    }

    public UserGroup(String userGroupID, String userGroupName, String userGroupDesc, String accessRights) {
        this.userGroupID = userGroupID;
        this.userGroupName = userGroupName;
        this.userGroupDesc = userGroupDesc;
        this.accessRights = accessRights;
    }

    public String getID() {
        return userGroupID;
    }

    public String getName() {
        return userGroupName;
    }

    public String getDesc() {
        return userGroupDesc;
    }

    public String getAccessRights() {
        return accessRights;
    }

    public void setID(String id) {
        this.userGroupID = userGroupID;
    }
    
    public void setName(String userGroupName) {
        this.userGroupName = userGroupName;
    }

    public void setDesc(String userGroupDesc) {
        this.userGroupDesc = userGroupDesc;
    }

    public void setAccessRights(String accessRights) {
        this.accessRights = accessRights;
    }

    @Override
    public String toString() {
        return String.format("%s %s %s", userGroupName, userGroupDesc, accessRights);
    }

}
