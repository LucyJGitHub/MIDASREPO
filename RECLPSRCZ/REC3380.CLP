/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE ACCRUED INTEREST & CHARGES REPORT')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                   */
/*                                                                   */
/*       REC3380 - ACCRUED INTEREST AND CHARGES REPORT               */
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
/*       Prev Amend No. 086412             Date 19Apr95              */
/*                      S01408             Date 11May95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       086412 - Ensure that files REAIXA,D,Z are cleared then      */
/*                set up by calling RE0379. Also remove redundant    */
/*                security copying of REACRA,D,Z as these are not    */
/*                updated. Component is now effectively the same as  */
/*                REC0380 except for different entry parameters.     */
/*       S01408 - Addition of core hook REC3380MP1                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/************DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)            */ /*086412*/
/************DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)               */ /*086412*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/************DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')   */ /*086412*/
/************DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)          */ /*086412*/
/**/
             MONMSG   MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR) /*086412*/
/**/
/*/COPY WNCPYSRC,REC3380MP1                                          */
                                                                      /*S01408*/
             CHGJOB     SWS(00000000)                                 /*086412*/
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABRE2)                    /*086412*/
/**/
             CLRPFM     FILE(REAIXA)                                  /*086412*/
             CLRPFM     FILE(REAIXD)                                  /*086412*/
             CLRPFM     FILE(REAIXZ)                                  /*086412*/
/**/
             CALL       PGM(RE0379)                                   /*086412*/
/**/
             IF COND(%SWITCH(XXXXXX0X)) THEN(DO)                      /*086412*/
                IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                   THEN(DO)                                           /*086412*/
                   OVRDBF FILE(SREAI) POSITION(*KEY 2 +
                   REAIXDF ('D' *CAT &RENT))                          /*086412*/
                   OPNDBF FILE(SREAI) OPTION(*ALL)                    /*086412*/
                   MONMSG MSGID(CPF0000) EXEC(DO)                     /*086412*/
                   DLTOVR FILE(SREAI)                                 /*086412*/
                   ENDDO                                              /*086412*/
                ENDDO                                                 /*086412*/
             ENDDO                                                    /*086412*/
/**/
             CALL       PGM(RE3380) PARM(&RSEQ &RENT)                 /*086412*/
/**/
             IF        COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END)) /*086412*/
 
ABNOR:                                                                /*086412*/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                      /*086412*/
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)               /*086412*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*086412*/
                SNDPGMMSG MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*086412*/
             ENDDO                                                    /*086412*/
/**/
             CHGVAR     VAR(&MEM) VALUE('REC3380 - Accrued Interest +
                          and Charges report terminated +
                          abnormally')                                /*086412*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MOPERQ MRUNQ)                /*086412*/
 
END:                                                                  /*086412*/
             DLTOVR     FILE(*ALL)                                    /*086412*/
             MONMSG     MSGID(CPF0000)                                /*086412*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*086412*/
/**/                                                                  /*086412*/
/************CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        */ /*086412*/
/************RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)        */ /*086412*/
/*************                                                     */ /*086412*/
/************CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))         */ /*086412*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')      */ /*086412*/
/*************                                                     */ /*086412*/
/************CHGJOB     SWS(00000000)                              */ /*086412*/
/*************                                                     */ /*086412*/
/************OVRDBF     FILE(REACRD) SEQONLY(*YES 100)             */ /*086412*/
/************OVRDBF     FILE(XREACRD) SEQONLY(*YES 100)            */ /*086412*/
/*************                                                     */ /*086412*/
/************IF         COND(&STAT *EQ 'N') THEN(DO)               */ /*086412*/
/*************  DLTF       FILE(XREACRA)                           */ /*086412*/
/*************  MONMSG     MSGID(CPF0000)                          */ /*086412*/
/*************  DLTF       FILE(XREACRD)                           */ /*086412*/
/*************  MONMSG     MSGID(CPF0000)                          */ /*086412*/
/*************  DLTF       FILE(XREACRZ)                           */ /*086412*/
/*************  MONMSG     MSGID(CPF0000)                          */ /*086412*/
/*************                                                     */ /*086412*/
/*************     CPYF   FROMFILE(REACRA) TOFILE(&TOLIB/XREACRA) +*/ /*086412*/
/*************           MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*086412*/
/*************     MONMSG (CPF2817) CMPDTA(CPF2869)                */ /*086412*/
/*************     CPYF   FROMFILE(REACRZ) TOFILE(&TOLIB/XREACRZ) +*/ /*086412*/
/*************           MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*086412*/
/*************     MONMSG (CPF2817) CMPDTA(CPF2869)                */ /*086412*/
/*************     CPYF   FROMFILE(REACRD) TOFILE(&TOLIB/XREACRD) +*/ /*086412*/
/*************           MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*086412*/
/*************     MONMSG (CPF2817) CMPDTA(CPF2869)                */ /*086412*/
/*************                                                     */ /*086412*/
/*************     CHGVAR     VAR(&STAT) VALUE('Y')                */ /*086412*/
/*************     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)  */ /*086412*/
/*************                                                     */ /*086412*/
/*************  ENDDO                                              */ /*086412*/
/*************                                                     */ /*086412*/
/*************  ELSE CMD(DO)                                       */ /*086412*/
/*************                                                     */ /*086412*/
/*************     RMVM       FILE(REACR) MBR(REACR)               */ /*086412*/
/*************     MONMSG     MSGID(CPF0000)                       */ /*086412*/
/*************                                                     */ /*086412*/
/*************     CPYF   FROMFILE(XREACRA) TOFILE(REACRA) +       */ /*086412*/
/*************            MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*086412*/
/*************     MONMSG (CPF2817) CMPDTA(CPF2869) +              */ /*086412*/
/*************            EXEC(CLRPFM REACRA)                      */ /*086412*/
/*************     CPYF   FROMFILE(XREACRZ) TOFILE(REACRZ) +       */ /*086412*/
/*************            MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*086412*/
/*************     MONMSG (CPF2817) CMPDTA(CPF2869) +              */ /*086412*/
/*************            EXEC(CLRPFM REACRZ)                      */ /*086412*/
/*************     CPYF   FROMFILE(XREACRD) TOFILE(REACRD) +       */ /*086412*/
/*************            MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*086412*/
/*************     MONMSG (CPF2817) CMPDTA(CPF2869) +              */ /*086412*/
/*************            EXEC(CLRPFM REACRD)                      */ /*086412*/
/*************                                                     */ /*086412*/
/*************     ADDLFM     FILE(REACR) MBR(REACR)               */ /*086412*/
/*************     MONMSG     MSGID(CPF0000)                       */ /*086412*/
/*************                                                     */ /*086412*/
/*************  ENDDO                                              */ /*086412*/
/*************                                                     */ /*086412*/
/*************  DLTOVR FILE(REACRD)                                */ /*086412*/
/*************  DLTOVR FILE(XREACRD)                               */ /*086412*/
/*************                                                     */ /*086412*/
/*************  IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +    */ /*086412*/
/*************     THEN(DO)                                        */ /*086412*/
/*************     OVRDBF FILE(SREAI) POSITION(*KEY 2 +            */ /*086412*/
/*************     REAIXDF ('D' *CAT &RENT))                       */ /*086412*/
/*************     OPNDBF FILE(SREAI) OPTION(*ALL)                 */ /*086412*/
/*************     MONMSG MSGID(CPF0000) EXEC(DO)                  */ /*086412*/
/*************      DLTOVR FILE(SREAI)                             */ /*086412*/
/*************      ENDDO                                          */ /*086412*/
/*************     ENDDO                                           */ /*086412*/
/*************                                                     */ /*086412*/
/*************  CALL   PGM(RE3380) PARM(&RSEQ &RENT)               */ /*086412*/
/*************  DLTOVR FILE(*ALL)                                  */ /*086412*/
/*************  MONMSG MSGID(CPF0000)                              */ /*086412*/
/*************                                                     */ /*086412*/
/*************  IF COND(%SWITCH(XXXXXX00)) THEN(DO)                */ /*086412*/
/*************     CHGVAR     VAR(&STAT) VALUE('N')                */ /*086412*/
/*************     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)  */ /*086412*/
/*************                                                     */ /*086412*/
/*************  DLTF       FILE(XREACRA)                           */ /*086412*/
/*************  MONMSG     MSGID(CPF0000)                          */ /*086412*/
/*************  DLTF       FILE(XREACRD)                           */ /*086412*/
/*************  MONMSG     MSGID(CPF0000)                          */ /*086412*/
/*************  DLTF       FILE(XREACRZ)                           */ /*086412*/
/*************  MONMSG     MSGID(CPF0000)                          */ /*086412*/
/*************  ENDDO                                              */ /*086412*/
/*************                                                     */ /*086412*/
/************IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                   */ /*086412*/
/*************  RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)            */ /*086412*/
/*************  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))          */ /*086412*/
/*************                                                     */ /*086412*/
/*************  SNDPGMMSG MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM)/+/*086412*/
/*************            TOMSGQ(MOPERQ MRUNQ)                     */ /*086412*/
/*************                                                     */ /*086412*/
/************ENDDO                                                 */ /*086412*/
/*************                                                     */ /*086412*/
/******CHGVAR*&BISCPY '(C) COPYRIGHT MKI LIMITED 1994'/ /*086412*/
/*DPGM:******ENDPGM                                                */ /*086412*/
