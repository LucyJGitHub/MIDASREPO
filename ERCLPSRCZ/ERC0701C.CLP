/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER - Clear Output Files')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC0701C - ER Clear Output Files                            */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX046             Date 31Oct02              */
/*                      ULX004             Date 09Apr97              */
/*                      ART021 PT          Date 16SEP96              */
/*                      ER0126 ThL         Date 17DEC92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX046 - Circulars 2002/170-174-175 Integration             */
/*       ULX004 - Capital Adequacy                                   */
/*       ART021 - SNB ARTICLE 21 DEVELOPMENT                         */
/*       ER0126 - Call of the Audit program: add an OVRDBF           */
/*                                                                   */
/*********************************************************************/
/**/
/*           PGM        PARM(&ICCD)                                   *ART021*/
             PGM        PARM(&ICCD &PREFIX)                          /*ART021*/
 
             DCL        VAR(&ICCD) TYPE(*CHAR) LEN(2) /* Country OR +
                          Application code */
/*********** DCL        VAR(&XXERDLIB) TYPE(*CHAR) LEN(10) +
                              /* MIDAS ER Data base library    /*ART021 ULX004*/
/**********  DCL        VAR(&XXCADLIB) TYPE(*CHAR) LEN(10) +
                              /* MIDAS ER Data base library */                     /*ULX004 CER001*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2) /* Midas +
                          subsystem prefix*/                         /*ART021*/
             DCL        VAR(&XXDPLIB) TYPE(*CHAR) LEN(10)                                 /*CER001*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')                                      /*ULX004*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*ULX046*/
             DCL        VAR(&ULX046)  TYPE(*CHAR) LEN(1) VALUE('N')   /*ULX046*/
 
/**********  DCLF       FILE(EROUTFPD) RCDFMT(EROUTFF0)                                   /*CER001*/
             DCLF       FILE(EROUTXPD) RCDFMT(EROUTFF0)                                   /*CER001*/
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
                                                                                          /*CER001*/
             CHGVAR     VAR(&XXDPLIB) VALUE(&PREFIX *CAT 'DPLIB')                         /*CER001*/
 
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY'   +
                          'ULX046')                                   /*ULX046*/
             IF         COND(&RETCOD = '      ') THEN(CHGVAR +
                          VAR(&ULX046) VALUE('Y'))                    /*ULX046*/
 
/************CHGVAR   VAR(&XXERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')ART021 ULX004*/
/**********  CHGVAR     VAR(&XXCADLIB) VALUE(&PREFIX *CAT 'CADLIB')       */       /*ULX004 CER001*/
 /*          CPYF       FROMFILE(&XXERDLIB/ERCHTRPD) +
                          TOFILE(&XXERDLIB/XERCHTRPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)        ART021 ULX004*/
 /*          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/XERCHTRPD))            ART021 ULX004*/
/**********  CPYF       FROMFILE(&XXCADLIB/ERLUTRPD) +
                          TOFILE(&XXCADLIB/XERLUTRPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */       /*ULX004 CER001*/
             CPYF       FROMFILE(ERLTRXPD) TOFILE(&XXDPLIB/XERLTRXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/XERLUTRPD))                      */       /*ULX004 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XERLTRXPD))                                                /*CER001*/
/**********  CPYF       FROMFILE(&XXCADLIB/ERLUCAPD) +
                          TOFILE(&XXCADLIB/XERLUCAPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */       /*ULX004 CER001*/
             CPYF       FROMFILE(ERLCAXPD) TOFILE(&XXDPLIB/XERLCAXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/XERLUCAPD))                      */       /*ULX004 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XERLCAXPD))                                                /*CER001*/
                                                                     /*ULX046*/
             IF         COND(&ULX046 = 'Y') THEN(DO)                 /*ULX046*/
                                                                     /*ULX046*/
/**********  CPYF       FROMFILE(&XXCADLIB/ERLU28PP) +
                          TOFILE(&XXCADLIB/XERLU28PP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */       /*ULX046 CER001*/
             CPYF       FROMFILE(ERL28XPD) TOFILE(&XXDPLIB/XERL28XPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/XERLU28PP))                      */       /*ULX046 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XERL28XPD))                                                /*CER001*/
                                                                     /*ULX046*/
/**********  CPYF       FROMFILE(&XXCADLIB/ERLU29PP) +
                          TOFILE(&XXCADLIB/XERLU29PP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */       /*ULX046 CER001*/
             CPYF       FROMFILE(ERL29XPD) TOFILE(&XXDPLIB/XERL29XPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/XERLU29PP))                      */       /*ULX046 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XERL29XPD))                                                /*CER001*/
                                                                     /*ULX046*/
             ENDDO                                                   /*ULX046*/
 
 LOOP:   RCVF       RCDFMT(EROUTFF0)
         MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOJ))
 
             IF         COND(&ERICCD *EQ &ICCD) THEN(DO)
             CLRPFM     FILE(&EROUTF)
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
/************SNDPGMMSG  MSG('ERC0701C - Clear file' *BCAT &EROUTF *TCAT ' +
                          ended in error.') TOMSGQ(ERMSGQ)            ULX004*/
/**********  SNDPGMMSG  MSG('ERC0701C - Clear file' *BCAT &EROUTF *TCAT ' +
                          ended in error.') TOMSGQ(CADMSGQ)               */       /*ULX004 CER001*/
             SNDPGMMSG  MSG('ERC0701C - Clear file' *BCAT &EROUTF *TCAT ' +
                          ended in error.') TOMSGQ(MOPERQ)                                /*CER001*/
             MONMSG     MSGID(CPF0000)
 
                                            ENDDO
             OVRDBF     FILE(&EROUTF) SEQONLY(*YES)           /*ER0126*/
             MONMSG     MSGID(CPF0000)                        /*ER0126*/
                                                      ENDDO
         GOTO LOOP
/*------------------------ ERROR  --------------------------------*/
 ERROR:      CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
/************SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA('ERC0701C  +
                          001') TOMSGQ(ERMSGQ)                         ULX004*/
/**********  SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA('ERC0701C  +
                          001') TOMSGQ(CADMSGQ)                           */       /*ULX004 CER001*/
             SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA('ERC0701C  +
                          001') TOMSGQ(MOPERQ)                                            /*CER001*/
             MONMSG     MSGID(CPF0000)
 
/******EOJ:         ENDPGM                                              ULX004*/
EOJ:                                                                  /*ULX004*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')                              /*ULX004*/
             ENDPGM                                                   /*ULX004*/
