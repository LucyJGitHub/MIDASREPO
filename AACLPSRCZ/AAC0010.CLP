/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AA Call book-profit centre matrix maint')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting module                        */
/*                                                                   */
/*       AAC0010 - Call Book-Profit Centre Matrix Maintenance        */
/*                 For Switchable Feature Initialisation.            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CAC005  *Create    Date 13Apr99              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAC005 - Profit Centre Accounting - SE Enhancement.         */
/*                - CAC005 initialisation control program.           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
/*/COPY WNCPYSRC,AAC0010INT                                          */
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,AAC0010MPS                                          */
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
                CALL       PGM(SEC0317)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSG('Program SEC0317 ended abnormally') +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)
                GOTO       CMDLBL(END)
                ENDDO
             ENDDO
/*/COPY WNCPYSRC,AAC0010001                                          */
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
                CALL       PGM(SEC0317)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSG('Program SEC0317 ended abnormally') +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)
                GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,AAC0010MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,AAC0010ERR                                          */
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /* Send the error message */
 
             SNDPGMMSG  MSG('Program AAC0010 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,AAC0010END                                          */
 
             ENDPGM
