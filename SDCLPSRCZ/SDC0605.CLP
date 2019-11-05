/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Reorganisation of SD Files')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0605 - File Reorganisation                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      055652             Date 25Jan96              */
/*                      S01408             Date 10MAY95              */
/*                      S01495             DATE 01OCT94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       BG18886 - Amend non-standard codes.                         */
/*       055652 - Move creation of temporary file to SDC0605A.       */
/*              - Remove reference to TABLETJ.                       */
/*              - Remove reference to TABLET4.                       */
/*       S01408 - Addition of core hook SDC0605MP1.                  */
/*       S01495 - COB enhancements.                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRM01 &RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&PRM01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SWITCH) TYPE(*CHAR) LEN(8)               /*055652*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*055652*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
             RTVJOBA    JOB(&JOB) USER(&USER) DATE(&DATE)
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/**********  CHGVAR     VAR(&LIB) VALUE(%SUBSTRING(&SDSTAT 6 2) ******* */ /*BG18886*/
/**********               'DPLIB')                                      */ /*BG18886*/
             CHGVAR     VAR(&LIB) VALUE(%SUBSTRING(&SDSTAT 6 2) *CAT +
                          'DPLIB')                                         /*BG18886*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC0605MP1                                          */
                                                                      /*S01408*/
/**/
             IF         COND(&PRM01 *EQ 'CLINT') THEN(DO)
               OVRDBF     FILE(CLINT2) TOFILE(CLINT)
               OVRDBF     FILE(TABLE) TOFILE(TABSDU)
               CALL       PGM(SD0650)
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               DLTOVR     FILE(*ALL)
/**/
/**********    CRTPF      FILE(&LIB/F256) RCDLEN(256) TEXT('Midas +   /*055652*/
/**********               SD Temporary File') SHARE(*YES) LVLCHK(*NO) /*055652*/
               CHGVAR     VAR(&MODE) VALUE('C')                       /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(CLINTCB F256)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(CLINTCC F256)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(CLINTC1 F256)            /*055652*/
               CALL       PGM(SDC0605A) PARM(CLINTCB &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(CLINTCC &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(CLINTC1 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
/*/COPY WNCPYSRC,SDC0605001                                          */
/**********    DLTF       FILE(F256) **/                              /*055652*/
             ENDDO
 /**/
             IF         COND(&PRM01 *EQ 'ACKEY') THEN(DO)
/**********    CRTPF      FILE(&LIB/F96A) RCDLEN(96) TEXT('Midas SD + /*055652*/
/**********                 Temporary file') SHARE(*YES) LVLCHK(*NO)  /*055652*/
               CHGVAR     VAR(&MODE) VALUE('A')                       /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(ACKEYAL F96A)            /*055652*/
               CALL       PGM(SDC0605A) PARM(ACKEYAL &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
/**********    DLTF       FILE(F96A)                                  /*055652*/
/*/COPY WNCPYSRC,SDC0605002                                          */
             ENDDO
/**/
             IF         COND(&PRM01 *EQ 'TABLE') THEN(DO)
/**********    CRTPF      FILE(&LIB/F96) RCDLEN(96) TEXT('Midas SD +  /*055652*/
/**********                 Temporary file') SHARE(*YES) LVLCHK(*NO)  /*055652*/
/**********    CRTPF      FILE(&LIB/F180) RCDLEN(180) TEXT('Midas +   /*055652*/
/**********               SD Temporary File') SHARE(*YES) LVLCHK(*NO) /*055652*/
               CHGVAR     VAR(&MODE) VALUE('T')                       /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETH F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETI F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETJ F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETK F180)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETL F180)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETM F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETN F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETO F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETP F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETQ F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETR F180)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETS F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETT F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETV F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETW F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLETZ F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLET1 F180)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLET2 F180)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLET3 F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLET4 F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLET5 F180)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLET6 F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLEUP F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLEUQ F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABLEUR F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABTE10 F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABTE20 F96)             /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABTG10 F180)            /*055652*/
/**********    CALL       PGM(SDC0605A) PARM(TABTG20 F96)             /*055652*/
/******>*/
               CALL       PGM(SDC0605A) PARM(TABLETH &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETI &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETK &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETL &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETM &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETN &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETO &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETP &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETQ &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETR &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETS &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETT &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETV &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETW &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLETZ &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLET1 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLET2 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLET3 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLET5 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLET6 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLEUP &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLEUQ &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABLEUR &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABTE10 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABTE20 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABTG10 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
               CALL       PGM(SDC0605A) PARM(TABTG20 &MODE)           /*055652*/
               RTVJOBA    SWS(&SWITCH)                                /*055652*/
               IF         COND(%SST(&SWITCH 8 1) *EQ '1') THEN(GOTO +
                            CMDLBL(ABNOR))                            /*055652*/
/**********    DLTF       FILE(F96)                                   /*055652*/
/**********    DLTF       FILE(F180)                                  /*055652*/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:                                                               /*055652*/
/*ABNOR:***  DLTF       FILE(F96)                                     /*055652*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*055652*/
/**********  DLTF       FILE(F96A)                                    /*055652*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*055652*/
/**********  DLTF       FILE(F180)                                    /*055652*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*055652*/
/**********  DLTF       FILE(F256)                                    /*055652*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*055652*/
             DMPCLPGM                                                 /*055652*/
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('File reorganisation ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
