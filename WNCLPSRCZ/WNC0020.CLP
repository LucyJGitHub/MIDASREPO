/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas WN Retrieve message text for title')            */
/*********************************************************************/
/*                                                                   */
/* Midas - WINDOWS                                           */
/*                                                                   */
/* WNC0020 - RETRIEVE MESSAGE TEXT FOR TITLE                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      PREV AMEND NO. S01407                DATE 24MAR93            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      MD046248 - Finastra Rebranding                               */
/*      S01407  -  SWITCHABILITY ENHANCEMENTS                        */
/*                 USE MESSAGE FILE FOR CLIENT MODIFICATIONS (XX)    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSG &TEXT)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*********** RTVMSG     MSGID(&MSG) MSGF(WNMSGF) MSG(&TEXT)   *****/  /*S01407*/
             RTVMSG     MSGID(&MSG) MSGF(XXUSRMSG) MSG(&TEXT)         /*S01407*/
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
