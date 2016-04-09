/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing messages by transaction')              */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0530 - Outgoing messages by transaction summary         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  S01408           DATE 05AUG96              */
/*       PREV AMEND NO.  X00000           DATE 00XXX00              */
/*                                                                  */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Core Hook MEC0530003 Added                         */
/*              - Core Hook MEC0530002 Added                         */
/*              - Core Hook MEC0530001 Added                         */
/*              - Core Hook MEC0530INT Added                         */
/*              - Core Hook MEC0530MPS Added                         */
/*                                                                   */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
/*                                                                 */ /*S01408*/
/*/COPY WNCPYSRC,MEC0530001                                        */ /*S01408*/
/*                                                                 */ /*S01408*/
             PGM
/*                                                                 */ /*S01408*/
/*/COPY WNCPYSRC,MEC0530INT                                        */ /*S01408*/
/*                                                                 */ /*S01408*/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                 */ /*S01408*/
/*/COPY WNCPYSRC,MEC0530002                                        */ /*S01408*/
/*                                                                 */ /*S01408*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
             OVRDBF     FILE(MGOMSGPD) SHARE(*NO)
             OVRDBF     FILE(MGOREFLU) TOFILE(MGOREFL0) SHARE(*NO)
 
/*                                                                 */ /*S01408*/
/*/COPY WNCPYSRC,MEC0530MPS                                        */ /*S01408*/
/*                                                                 */ /*S01408*/
             CALL       PGM(ME0530)
/*                                                                 */ /*S01408*/
/*/COPY WNCPYSRC,MEC0530003                                        */ /*S01408*/
/*                                                                 */ /*S01408*/
 
/* Check for database errors */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Outgoing Messages by Transaction +
                          Summary ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        DLTOVR     FILE(MGOREFLU)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
