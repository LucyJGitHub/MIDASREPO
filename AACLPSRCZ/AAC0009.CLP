/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AA Call book prf centre comb determ report')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting module                        */
/*                                                                   */
/*       AAC0009 - Call SE Book Prf Centre Combination Determination */
/*                 For Switchable Feature Initialisation.            */
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
/*       Prev Amend No. CAC005  *CREATE    Date 13Apr99              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAC005 - Profit Centre Accounting - SE Enhancement.         */
/*                - CAC005 initialisation control program.           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
/*/COPY WNCPYSRC,AAC0009INT                                          */
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,AAC0009MPS                                          */
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
                CLRPFM     FILE(SDBKP1PD)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(AA0016)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSG('Program AA0016 ended abnormally') +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)
                GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
                CLRPFM     FILE(SDBKP1PD)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(AA0016)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSG('Program AA0016 ended abnormally') +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)
                GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,AAC0009MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,AAC0009ERR                                          */
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /* Send the error message */
 
             SNDPGMMSG  MSG('Program AAC0009 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,AAC0009END                                          */
 
             ENDPGM
