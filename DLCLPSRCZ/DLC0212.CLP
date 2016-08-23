/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Brokerage Rates File Maintenance')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0212-BROKERAGE RATES FILE MAINTENANCE                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01199                  DATE  06/04/89      */
/*       PREV AMEND NO. S01194                  DATE  01/09/89      */
/********************************************************************/
/*       S01199 -  Help System. This change allows only the      */
/*                brokerage rates ,London  to be maintained.        */
/*       S01194 - NEW STANDING DATA FILES                           */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/*     BROKERAGE RATES FILE MAINTENANCE                       */
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
/************CALL       PGM(DL0095)                                 /*S01199*/
             CALL       PGM(DL0095) PARM('01')                      /*S01199*/
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
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
