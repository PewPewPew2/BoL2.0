/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javafxapplication2;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ToggleButton;

/**
 *
 * @author PewPewPew
 */
public class FXMLDocumentController implements Initializable {
    
    String characters[] = new String[12];
    
    @FXML private CheckBox queueCoopVsAi;
    @FXML private CheckBox queueTeamBuilder;
    @FXML private CheckBox queueDraftPick;
    @FXML private CheckBox queueBlindPick;
    
    @FXML private ToggleButton charBlitzcrank;
    @FXML private ToggleButton charSona;
    @FXML private ToggleButton charSoraka;
    @FXML private ToggleButton charFiddleSticks;
    @FXML private ToggleButton charZilean;
    @FXML private ToggleButton charZyra;
    @FXML private ToggleButton charJanna;
    @FXML private ToggleButton charNami;
    @FXML private ToggleButton charLux;
    @FXML private ToggleButton charMorgana;
    @FXML private ToggleButton charKarma;
    @FXML private ToggleButton charTaric;
    
    //queueCoopVsAi.isSelected()
    
    @FXML //exit app
    private void handleCloseAction(ActionEvent event) {
        Platform.exit();
    }
    
    @FXML //Start Queue
    private void handleStartAction(ActionEvent event) {
        System.out.println("You will start me one day");
    }
    
    @FXML //End Queue
    private void handleEndAction(ActionEvent event) {
        System.out.println("You will end me one day");
    }
    
    //Queue Type Start Here
    
    @FXML //BlindPick
    private void handleBlindPickSelect(ActionEvent event) {
        queueTeamBuilder.setSelected(false);
        queueCoopVsAi.setSelected(false);
        queueDraftPick.setSelected(false);
    }

    @FXML //CoopVsAi
    private void handleCoopVsAiSelect(ActionEvent event) {
        queueTeamBuilder.setSelected(false);
        queueBlindPick.setSelected(false);
        queueDraftPick.setSelected(false);
    }
    
    @FXML //DraftPick
    private void handleDraftPickSelect(ActionEvent event) {
        queueTeamBuilder.setSelected(false);
        queueBlindPick.setSelected(false);
        queueCoopVsAi.setSelected(false);        
    }
    
    @FXML //TeamBuilder
    private void handleTeamBuilderSelect(ActionEvent event) {
        queueCoopVsAi.setSelected(false);
        queueBlindPick.setSelected(false);
        queueDraftPick.setSelected(false);
    }
    
    //Characters Start Here
    
    @FXML
    private void handleAddLux(ActionEvent event) {
        if(charLux.isSelected()){
            characters[0] = "Lux";
        }else{
            characters[0] = null;
        }
    }

    @FXML
    private void handleAddBlitzcrank(ActionEvent event) {
        if(charBlitzcrank.isSelected()){
            characters[1] = "Blitzcrank";
        }else{
            characters[1] = null;
        }
    }
    
    @FXML
    private void handleAddKarma(ActionEvent event) {
        if(charKarma.isSelected()){
            characters[2] = "Karma";
        }else{
            characters[2] = null;
        }
    }
    
    @FXML
    private void handleAddFiddleSticks(ActionEvent event) {
        if(charFiddleSticks.isSelected()){
            characters[3] = "FiddleSticks";
        }else{
            characters[3] = null;
        }
    }
    
    @FXML
    private void handleAddJanna(ActionEvent event) {
        if(charJanna.isSelected()){
            characters[4] = "Janna";
        }else{
            characters[4] = null;
        }
    }
    
    @FXML
    private void handleAddMorgana(ActionEvent event) {
        if(charMorgana.isSelected()){
            characters[5] = "Morgana";
        }else{
            characters[5] = null;
        }
    }
    
    @FXML
    private void handleAddTaric(ActionEvent event) {
        if(charTaric.isSelected()){
            characters[6] = "Taric";
        }else{
            characters[6] = null;
        }
    }
    
    @FXML
    private void handleAddZilean(ActionEvent event) {
        if(charZilean.isSelected()){
            characters[7] = "Zilean";
        }else{
            characters[7] = null;
        }
    }
    
    @FXML
    private void handleAddZyra(ActionEvent event) {
        if(charZyra.isSelected()){
            characters[8] = "Zyra";
        }else{
            characters[8] = null;
        }
    }
    
    @FXML
    private void handleAddNami(ActionEvent event) {
        if(charNami.isSelected()){
            characters[9] = "Nami";
        }else{
            characters[9] = null;
        }
    }
    
    @FXML
    private void handleAddSona(ActionEvent event) {
        if(charSona.isSelected()){
            characters[10] = "Nami";
        }else{
            characters[10] = null;
        }
    }
    
    @FXML
    private void handleAddSoraka(ActionEvent event) {
        if(charSoraka.isSelected()){
            characters[11] = "Soraka";
            for (String i : characters)
                if(i!=null)
                    System.out.println(i);
        
        }else{
            characters[11] = null;
        }
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }    
    
}
