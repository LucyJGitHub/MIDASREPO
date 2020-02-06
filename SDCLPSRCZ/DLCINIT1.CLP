/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL CLP for switchable feature init')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLCINIT1  - Create transaction classes in file SDTCLSPD     */
/*                   (based on what s input to SDTCLDPD).            */
/*                                                                   */
/*       (c) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL038A *CREATE    Date 25Jan06              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL038A - Init programs for CDL038.                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
/*/COPY WNCPYSRC,mmCnnnnINT                                          */
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2006')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,mmCnnnnMPS                                          */
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
 
             CALL       DLCLINI1
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO ABNOR)
 
             ENDDO
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
 
             CALL       DLCLINI1
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO ABNOR)
 
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
/* >>>>> Add switching off processing here */
             ENDDO
 
/*/COPY WNCPYSRC,mmCnnnnMPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,mmCnnnnERR                                          */
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /* Send the error message */
 
             SNDPGMMSG  MSG('Program DLCINIT1 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,mmCnnnnEND                                          */
 
/* (Add any specific end processing here) */
 
             ENDPGM
