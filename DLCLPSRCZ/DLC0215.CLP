/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Brokerage Rates File Maint. - Lux.')         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0215 -BROKERAGE RATES FILE MAINTENANCE (LUXEMBOURG)     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194             Date 27Nov89              */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - RELEASE 10 NEW STANDING DATA FILES                */
/*       S01199 - PGM NEW FOR ON LINE HELP TEXT                     */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/*     BROKERAGE RATES FILE MAINTENANCE                       */
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
             CALL       PGM(DL0095) PARM('02')
/************DLTOVR     FILE(*ALL)                                    /*S01194*/
/*     ERROR MESSAGES                                         */
             IF         COND(*NOT %SWITCH(XXX00000)) THEN(DO)
                IF        COND(%SWITCH(XXXXXX11)) THEN(DO)
                   CHGVAR    VAR(&MSG) VALUE('JOB TERMINATED-+
                                              DATABASE IN ERROR')
                ENDDO
                RTVJOBA    JOB(&JOB)
                SNDPGMMSG MSG(&MSG) TOMSGQ(&JOB) MSGTYPE(*INFO)
                SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
ENDPGM:      ENDPGM
