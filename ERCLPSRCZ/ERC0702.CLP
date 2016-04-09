/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER -Interface to FRS Component')                */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0702 - EUROPEAN REPORTING                                 */
/*               INTERFACE TO FRS MAIN COMPONENT                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX047             Date  17Dec02             */
/*                      ULX046             Date  31Oct02             */
/*                    ULX040             Date  20Feb01              */
/*                    187689             Date  21Dec00              */
/*                    182312             Date  30Oct00              */
/*                    ULX012             Date  15Dec98              */
/*                    ULX004             Date  18MAR97              */
/*                    ER_R10             Date  08AUG95              */
/*                    ERL440 PT          DATE  03SEP94              */
/*                    ERL438 PT          DATE  03SEP94              */
/*                    ERL436 PT          DATE  03SEP94              */
/*                    ERL414 PT          DATE  26JUL94              */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     ULX047 - CSSF Market Values Calculation                      */
/*     ULX046 - Circulars 2002/170-174-175 Integration              */
/*     ULX040 - FIRE - RT30 Generation in Midas                     */
/*              Call new CLP ERC0710 to format and Download RT30    */
/*     187689 - BRD Currency in EMU                                 */
/*     182312 - Interest to accrue not managed                      */
/*     ULX012 - Guarantees and Collateral Management enhancements   */
/*              Recompile over changed file ERLUICPD                */
/*     ULX004 - Capital Adequacy                                    */
/*     ER_R10 - UPGRADE IML TO RELEASE 10                           */
/*     ERL440 - GLOBAL ERROR TRAP NOT CORRECTLY MANAGED             */
/*     ERL438 - CUSTOMER POSITIONS MANAGEMENT                       */
/*     ERL436 - DISCRETIONARY CUSTOMER ASSETS MANAGEMENT            */
/*     ERL414 - CHANGE INVOCATION LEVEL TO AVOID PROBLEMS WITH      */
/*              THE RECLAIM RESOURCE COMMAND                        */
/*                                                                  */
/*********************************************************************/
 
/***         PGM        PARM(&ERPGM &BJMRDT &BJURPT &VDICNA &RETURN)    ULX040*/
             PGM        PARM(&ERPGM &BJMRDT &BJURPT &VDICNA &RETURN +
                          &PREFIX)                                    /*ULX040*/
 
             DCL        VAR(&ERPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BJMRDT) TYPE(*CHAR) LEN(7) /* MIDAS +
                          report date */
             DCL        VAR(&BJURPT) TYPE(*CHAR) LEN(53) /* Title */
             DCL        VAR(&VDICNA) TYPE(*CHAR) LEN(20) /* Country */
             DCL        VAR(&LASTSQ) TYPE(*DEC) LEN(6 0) /* Last +
                          Record Sequence number generated - ER0336 */
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(52)  /* Error +
                          Message data */
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1) /* Return code */
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(7) +
                          VALUE('ERC0702') /* Return code */
             DCL        VAR(&LASTCP) TYPE(*DEC) LEN(6 0) /* Dummy Last +
                          Record Sequence number generated -          ERL438 */
             DCL        VAR(&LASTCA) TYPE(*DEC) LEN(6 0) /* Dummy Last +
                          Record Sequence number generated -          ULX004 */
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)               /*ULX040*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*ULX040*/
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200)             /*ULX040*/
             DCL        VAR(&ERRFLAG) TYPE(*CHAR) LEN(1) VALUE('N')   /*ULX040*/
             DCL        VAR(&ULX046)  TYPE(*CHAR) LEN(1) VALUE('N')   /*ULX046*/
/**********  DCL        VAR(&XXCADLIB) TYPE(*CHAR) LEN(10)                */       /*ULX047 CER001*/
 
  /*  LMI I.C.D. file */
 
/**********  DCLF       FILE(ERLUICPD) RCDFMT(ERLUICD0)                   */       /*ULX004 CER001*/
             DCLF       FILE(ERLICXPD) RCDFMT(ERLUICD0)                                   /*CER001*/
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ERROR))
 
/************OVRDBF     FILE(EREXTRL0) SEQONLY(*YES)                  ERL438 */
 
      /* Send 'started' message                               */
 /*          SNDPGMMSG  MSG('ERC0702 -' *BCAT &VDICNA *TCAT ' +
                          Reporting Interface to FRS starts') +
                          TOMSGQ(ERMSGQ)                             ULX004*/
/**********  SNDPGMMSG  MSG('ERC0702 -' *BCAT &VDICNA *TCAT ' +
                          Reporting Interface to FRS starts') +
                          TOMSGQ(CADMSGQ)                                 */       /*ULX004 CER001*/
             SNDPGMMSG  MSG('ERC0702 -' *BCAT &VDICNA *TCAT ' +
                          Reporting Interface to FRS starts') +
                          TOMSGQ(MOPERQ)                                                  /*CER001*/
 
/*********   CHGVAR     VAR(&XXCADLIB) VALUE(&PREFIX *CAT 'CADLIB')       */       /*ULX047 CER001*/
 
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY'   +
                          'ULX046' &FMT200)                         /*ULX046*/
             IF         COND(&RETCOD = '      ') THEN(CHGVAR +
                          VAR(&ULX046) VALUE('Y'))                  /*ULX046*/
 
/* SPECIFIC PROCESSING:                                           */
/************SNDPGMMSG  MSG(&ERPGM *BCAT '- MAIN COMPONENT') +
                          TOMSGQ(ERMSGQ) MSGTYPE(*INFO)               ERL438 */
/*     1. Without customer positions                                  ERL438 */
/************SNDPGMMSG  MSG(&ERPGM *BCAT '- Main Component Without +
                          Customer Positions') TOMSGQ(ERMSGQ) +
                          MSGTYPE(*INFO)                     /* ERL438 ULX004*/
 
             IF         COND(&ULX046 = 'N') THEN(DO)                /*ULX046*/
 
/**********  SNDPGMMSG  MSG(&ERPGM *BCAT '- Main Component Without +
                          Customer Positions') TOMSGQ(CADMSGQ) +
                          MSGTYPE(*INFO)                                  */       /*ULX004 CER001*/
             SNDPGMMSG  MSG(&ERPGM *BCAT '- Main Component Without +
                          Customer Positions') TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                                                  /*CER001*/
/*        Exclude customer positions                                  ERL438 */
/**********  OVRDBF     FILE(EREXTRL0) TOFILE(EREXTRL3) +
                          SEQONLY(*YES)                                   */       /*ERL438 CER001*/
             OVRDBF     FILE(EREXTXL0) TOFILE(EREXTXL3) +
                          SEQONLY(*YES)                                                   /*CER001*/
 
             ENDDO                                                  /*ULX046*/
 
             IF         COND(&ULX046 = 'Y') THEN(DO)                /*ULX046*/
 
/**********  SNDPGMMSG  MSG(&ERPGM *BCAT '- Main Component') +
                          TOMSGQ(CADMSGQ) MSGTYPE(*INFO)                  */       /*ULX046 CER001*/
             SNDPGMMSG  MSG(&ERPGM *BCAT '- Main Component') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)                                   /*CER001*/
 
             ENDDO                                                  /*ULX046*/
 
             CALL       PGM(&ERPGM) PARM(&BJMRDT &BJURPT &LASTSQ)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             CHGVAR     VAR(&PGM) VALUE(&ERPGM)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF         COND(&ULX046 = 'N') THEN(DO)                /*ULX046*/
 
/*           If the feature is On,                                         ULX046*/
/*           The S1.4 Report 'Customer Positions' is no more consolidated  ULX046*/
 
/*     2. With customer positions                                     ERL438 */
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)           /* ERL438 */
             RCLRSC     LVL(*)                                     /* ERL438 */
/************SNDPGMMSG  MSG(&ERPGM *BCAT '- Main Component With +
                          Customer Positions') TOMSGQ(ERMSGQ) +
                          MSGTYPE(*INFO)                    /* ERL438 ULX004*/
/**********  SNDPGMMSG  MSG(&ERPGM *BCAT '- Main Component With +
                          Customer Positions') TOMSGQ(CADMSGQ) +
                          MSGTYPE(*INFO)                                  */       /*ULX004 CER001*/
             SNDPGMMSG  MSG(&ERPGM *BCAT '- Main Component With +
                          Customer Positions') TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                                                  /*CER001*/
/*        Include customer positions                                  ERL438 */
/**********  OVRDBF     FILE(EREXTRL0) TOFILE(EREXTRL4) +
                          SEQONLY(*YES) /* ERL438 */                               /*ERL438 CER001*/
             OVRDBF     FILE(EREXTXL0) TOFILE(EREXTXL4) +
                          SEQONLY(*YES)                                                   /*CER001*/
/*        Generate records on a temporary file                        ERL438 */
/**********  CLRPFM     FILE(ERLUCPPD)                                    */       /*ERL438 CER001*/
             CLRPFM     FILE(ERLCPXPD)                                                    /*CER001*/
/**********  OVRDBF     FILE(ERLUTRPD) TOFILE(ERLUCPPD)                   */       /*ERL438 CER001*/
             OVRDBF     FILE(ERLTRXPD) TOFILE(ERLCPXPD)                                   /*CER001*/
                                                                   /* ERL438 */
             CALL       PGM(&ERPGM) PARM(&BJMRDT &BJURPT &LASTCP)  /* ERL438 */
                                                                   /* ERL438 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    /* ERL438 */
             CHGVAR     VAR(&PGM) VALUE(&ERPGM)                    /* ERL438 */
             GOTO       CMDLBL(ERROR)                              /* ERL438 */
             ENDDO                                                 /* ERL438 */
             DLTOVR     FILE(*ALL)                                 /* ERL438 */
             ENDDO                                                 /* ERL438 */
                                                                   /* ERL438 */
/* IML 1.1/2.5 Consolidated customer positions generation          /* ERL438 */
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)           /* ERL438 */
             RCLRSC     LVL(*)                                     /* ERL438 */
/************SNDPGMMSG  MSG('ERLU114 - Customer Positions +
                          Generation') TOMSGQ(ERMSGQ) +
                          MSGTYPE(*INFO)                    /* ERL438 ULX004 */
/**********  SNDPGMMSG  MSG('ERLU114 - Customer Positions +
                          Generation') TOMSGQ(CADMSGQ) +
                          MSGTYPE(*INFO)                                  */       /*ULX004 CER001*/
             SNDPGMMSG  MSG('ERLU114 - Customer Positions +
                          Generation') TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                                                  /*CER001*/
             CALL       PGM(ERLU114) PARM(&LASTSQ)                 /* ERL438 */
                                                                   /* ERL438 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    /* ERL438 */
             CHGVAR     VAR(&PGM) VALUE('ERLU114')                 /* ERL438 */
             GOTO       CMDLBL(ERROR)                              /* ERL438 */
             ENDDO                                                 /* ERL438 */
             ENDDO                                                 /* ERL438 */
 
             ENDDO                                                  /*ULX046*/
                                                                    /*ULX046*/
             IF         COND(&ULX046 = 'Y') THEN(DO)                /*ULX046*/
                                                                    /*ULX046*/
/* Taux Contractuel Annualisé Generation (TCA) - Record type 28       ULX046*/
                                                                    /*ULX046*/
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)            /*ULX046*/
             RCLRSC     LVL(*)                                      /*ULX046*/
/**********  SNDPGMMSG  MSG('ERLU150 - Taux Contractuel Annualisé +
                          Generation') TOMSGQ(CADMSGQ) +
                          MSGTYPE(*INFO)                                  */       /*ULX046 CER001*/
             SNDPGMMSG  MSG('ERLU150 - Taux Contractuel Annualisé +
                          Generation') TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                                                  /*CER001*/
             CALL       PGM(ERLU150) PARM(&BJMRDT &BJURPT)          /*ULX046*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)     /*ULX046*/
             CHGVAR     VAR(&PGM) VALUE('ERLU150')                  /*ULX046*/
             GOTO       CMDLBL(ERROR)                               /*ULX046*/
             ENDDO                                                  /*ULX046*/
             RCLACTGRP  ACTGRP(*ELIGIBLE)                           /*ULX046*/
             ENDDO                                                  /*ULX046*/
                                                                    /*ULX046*/
/* Taux Annuel Effectif Global Generation (TAEG) - Record type 29     ULX046*/
                                                                    /*ULX046*/
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)            /*ULX046*/
             RCLRSC     LVL(*)                                      /*ULX046*/
/**********  SNDPGMMSG  MSG('ERLU151 - Taux Annuel Effectif Global +
                          generation') TOMSGQ(CADMSGQ) MSGTYPE(*INFO)     */       /*ULX046 CER001*/
             SNDPGMMSG  MSG('ERLU151 - Taux Annuel Effectif Global +
                          generation') TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                                                  /*CER001*/
             CALL       PGM(ERLU151) PARM(&BJMRDT &BJURPT)          /*ULX046*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)     /*ULX046*/
             CHGVAR     VAR(&PGM) VALUE('ERLU151')                  /*ULX046*/
             GOTO       CMDLBL(ERROR)                               /*ULX046*/
             ENDDO                                                  /*ULX046*/
             RCLACTGRP  ACTGRP(*ELIGIBLE)                           /*ULX046*/
             ENDDO                                                  /*ULX046*/
                                                                    /*ULX046*/
             ENDDO                                                  /*ULX046*/
 
/* IML 1.1/2.5 Dicretionary customer assets generation             /* ERL436 */
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)           /* ERL436 */
             RCLRSC     LVL(*)                                     /* ERL436 */
/************SNDPGMMSG  MSG('ERLU115 - Discretionary Customer assets +
                          Extract') TOMSGQ(ERMSGQ) MSGTYPE(*INFO) +
                                                              ERL436 ULX004*/
/**********  SNDPGMMSG  MSG('ERLU115 - Discretionary Customer assets +
                          Extract') TOMSGQ(CADMSGQ) MSGTYPE(*INFO) +
                                                                          */       /*ULX004 CER001*/
             SNDPGMMSG  MSG('ERLU115 - Discretionary Customer assets +
                          Extract') TOMSGQ(MOPERQ) MSGTYPE(*INFO)                         /*CER001*/
             CALL       PGM(ERLU115) PARM(&LASTSQ)                 /* ERL436 */
                                                                   /* ERL436 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    /* ERL436 */
             CHGVAR     VAR(&PGM) VALUE('ERLU115')                 /* ERL436 */
             GOTO       CMDLBL(ERROR)                              /* ERL436 */
             ENDDO                                                 /* ERL436 */
             ENDDO                                                 /* ERL436 */
                                                                   /* ERL436 */
/**IML*2.3*PROCESSING**/                                           /* ULX004 */
/**********                                                           ULX004 */
/**********  IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)              ULX004 */
/**********  RCLRSC     LVL(*)                                        ULX004 */
/**********  SNDPGMMSG  MSG('ERC0232 - IML 2.3 Extract') +            ULX004 */
/**********               TOMSGQ(ERMSGQ) MSGTYPE(*INFO)               ULX004 */
/**********  CALL       PGM(ERC0232) PARM(&LASTSQ)                    ULX004 */
/**********                                                           ULX004 */
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)       ULX004 */
/**********  CHGVAR     VAR(&PGM) VALUE('ERC0232')                    ULX004 */
/**********  GOTO       CMDLBL(ERROR)                                 ULX004 */
/**********  ENDDO                                                    ULX004 */
/**********  ENDDO                                                    ULX004 */
 
/**IML*1.4*PROCESSING**/                                           /* ULX004 */
/**********  IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)              ULX004 */
/**********  RCLRSC     LVL(*)                                        ULX004 */
/**********  SNDPGMMSG  MSG('ERLU141 - IML 1.4 Processing') +         ULX004 */
/**********                TOMSGQ(ERMSGQ) MSGTYPE(*INFO)              ULX004 */
/**********  CALL       PGM(ERLU141)                                  ULX004 */
/**********                                                           ULX004 */
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)       ULX004 */
/**********  CHGVAR     VAR(&PGM) VALUE('ERLU141')                    ULX004 */
/**********  GOTO       CMDLBL(ERROR)                                 ULX004 */
/**********  ENDDO                                                    ULX004 */
/**********  ENDDO                                                    ULX004 */
 
/* GUARANTEES GENERATION / PROVISIONS UPDATE */                    /* ULX004 */
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)           /* ULX004 */
             RCLRSC     LVL(*)                                     /* ULX004 */
/*           SNDPGMMSG  MSG('ERLU75 - Guarantees generation / +
                          Provision update') TOMSGQ(CADMSGQ) +
                          MSGTYPE(*INFO)                       ULX004  187689*/
/**********  SNDPGMMSG  MSG('ERLU75 - Guarantees generation / +
                          Provision update') TOMSGQ(CADMSGQ) +
                          MSGTYPE(*INFO)                                  /*       /*ULX004 CER001*/
             SNDPGMMSG  MSG('ERLU75 - Guarantees generation / +
                          Provision update') TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                                                  /*CER001*/
             CALL       PGM(ERLU75) PARM(&LASTSQ)                  /* ULX004 */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    /* ULX004 */
             CHGVAR     VAR(&PGM) VALUE('ERLU75')                  /* ULX004 */
             GOTO       CMDLBL(ERROR)                              /* ULX004 */
             ENDDO                                                 /* ULX004 */
             ENDDO                                                 /* ULX004 */
 
/* LMI CAD Allocation                                              /* ULX004 */
             RCVF       RCDFMT(ERLUICD0)                           /* ULX004 */
             IF         COND(&VPIM14 *EQ 'Y') THEN(DO)             /* ULX004 */
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)           /* ULX004 */
             RCLRSC     LVL(*)                                     /* ULX004 */
/**********  SNDPGMMSG  MSG('ERLUCA - LMI CAD Allocation') +
                          TOMSGQ(CADMSGQ) MSGTYPE(*INFO)                  */       /*ULX004 CER001*/
             SNDPGMMSG  MSG('ERLUCA - LMI CAD Allocation') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)                                   /*CER001*/
             CALL       PGM(ERLUCA) PARM(&BJMRDT &BJURPT &LASTCA)  /* ULX004 */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    /* ULX004 */
             CHGVAR     VAR(&PGM) VALUE('ERLUCA')                  /* ULX004 */
             GOTO       CMDLBL(ERROR)                              /* ULX004 */
             ENDDO                                                 /* ULX004 */
             ENDDO                                                 /* ULX004 */
 
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)           /* ULX047 */
/**********  CRTDUPOBJ  OBJ(ERLUCAPD) FROMLIB(&XXCADLIB) +
                          OBJTYPE(*FILE) NEWOBJ(WERLUCAPD) DATA(*YES)     */       /*ULX047 CER001*/
             CRTDUPOBJ  OBJ(ERLCAXPD) FROMLIB(*LIBL) +
                          OBJTYPE(*FILE) NEWOBJ(WERLCAXPD) +
                          DATA(*YES)                                                      /*CER001*/
/**********  CPYF       FROMFILE(&XXCADLIB/WERLUCAPD) +
                          TOFILE(&XXCADLIB/ERLUCAPD) +
                          MBROPT(*REPLACE) INCREL((*IF EXBKTP *EQ +
                          1))                                             */       /*ULX047 CER001*/
             CPYF       FROMFILE(WERLCAXPD) TOFILE(ERLCAXPD) +
                          MBROPT(*REPLACE) INCREL((*IF EXBKTP *EQ +
                          1))                                                             /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLUCAPD))                       */       /*ULX047 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERLCAXPD))                                                 /*CER001*/
/**********  DLTF       FILE(&XXCADLIB/WERLUCAPD)                         */       /*ULX047 CER001*/
             DLTF       FILE(WERLCAXPD)                                                   /*CER001*/
             ENDDO                                                 /* ULX047 */
 
             ENDDO                                                 /* ULX004 */
                                                                   /* 182312 */
/* BCL 1.2 Interest to accrue generation (column INA)              /* 182312 */
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)           /* 182312 */
             RCLRSC     LVL(*)                                     /* 182312 */
/**********  SNDPGMMSG  MSG('ERLU116 - Interest to Accrue +
                          Generation') TOMSGQ(CADMSGQ) +
                          MSGTYPE(*INFO)                                  */       /*182312 CER001*/
             SNDPGMMSG  MSG('ERLU116 - Interest to Accrue +
                          Generation') TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                                                  /*CER001*/
             CALL       PGM(ERC0116) PARM(&LASTSQ)                 /* 182312 */
                                                                   /* 182312 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)    /* 182312 */
             CHGVAR     VAR(&PGM) VALUE('ERLU116')                 /* 182312 */
             GOTO       CMDLBL(ERROR)                              /* 182312 */
             ENDDO                                                 /* 182312 */
             ENDDO                                                 /* 182312 */
 
                                                                      /*ULX040*/
/***  Check whether feature ULX040 is Present.  ***/                  /*ULX040*/
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY'   +
                          'ULX040' &FMT200)                           /*ULX040*/
             IF         COND(&RETCOD = '      ') THEN(DO)             /*ULX040*/
/**********       SNDPGMMSG  MSG('ERC0702 - Call ERC0710 - RT30 +
                             Generation in Midas') TOMSGQ(CADMSGQ) +
                             MSGTYPE(*INFO)                               /*       /*ULX040 CER001*/
             SNDPGMMSG  MSG('ERC0702 - Call ERC0710 - RT30 +
                          Generation in Midas') TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                                                  /*CER001*/
                  CALL       ERC0710 PARM(&PREFIX 'RT30' &ERRFLAG)    /*ULX040*/
                  MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)  /*ULX040*/
/**********       SNDPGMMSG  MSG('ERC0702 - Call ERC0710 - RT30 +
                             Generation in Midas Failure ') TOMSGQ(CADMSGQ) +
                             MSGTYPE(*INFO)                               */       /*ULX040 CER001*/
             SNDPGMMSG  MSG('ERC0702 - Call ERC0710 - RT30 +
                          Generation in Midas Failure ') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)                                   /*CER001*/
                  ENDDO                                               /*ULX040*/
                  IF         COND(&ERRFLAG *EQ 'Y') THEN(DO)          /*ULX040*/
                      IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)     /*ULX040*/
/** don't stop , manual i/C Menu                         **/          /*ULX040*/
                          CHGJOB     SWS(XXXXXX0X)
                      ENDDO                                           /*ULX040*/
 
/**********       SNDPGMMSG  MSG('ERC0702 - Call ERC0710 - RT30 +
                             Generation in Midas Failure ') TOMSGQ(CADMSGQ) +
                             MSGTYPE(*INFO)                               */       /*ULX040 CER001*/
             SNDPGMMSG  MSG('ERC0702 - Call ERC0710 - RT30 +
                          Generation in Midas Failure ') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)                                   /*CER001*/
                  ENDDO                                               /*ULX040*/
             ENDDO            /* ULX040 present */                    /*ULX040*/
 
/* IML 1.2 - COLUMN 13 PROCESSING */
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)
             RCLRSC     LVL(*)
/************SNDPGMMSG  MSG('ERC0121 - IML 1.2 Processing') +
                          TOMSGQ(ERMSGQ) MSGTYPE(*INFO)               ULX004*/
/************SNDPGMMSG  MSG('ERC0121 - IML 1.2 Processing') +
                          TOMSGQ(CADMSGQ) MSGTYPE(*INFO)     *ULX004* 187689*/
/**********  SNDPGMMSG  MSG('ERC0121 - Exchange Rates Extract') +
                          TOMSGQ(CADMSGQ) MSGTYPE(*INFO)                  */       /*187689 CER001*/
             SNDPGMMSG  MSG('ERC0121 - Exchange Rates Extract') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)                                   /*CER001*/
             CALL       PGM(ERC0121)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             CHGVAR     VAR(&PGM) VALUE('ERC0121')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSGDTA)
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MSGDTA) TOMSGQ(ERMSGQ)               ER_R10 */
/************SNDPGMMSG  MSGID(DBM0001) MSGF(ERUSRMSG) +
                          MSGDTA(&MSGDTA) TOMSGQ(ERMSGQ)               ULX004*/
/**********  SNDPGMMSG  MSGID(DBM0001) MSGF(ERUSRMSG) +
                          MSGDTA(&MSGDTA) TOMSGQ(CADMSGQ)           */             /*ULX004 CER001*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(STUSRMSG) +
                          MSGDTA(&MSGDTA) TOMSGQ(MOPERQ)                                  /*CER001*/
             CHGVAR     VAR(&RETURN) VALUE('Y')
             ENDDO
 
             GOTO       CMDLBL(EOJ)
 
 ERROR: /****SNDPGMMSG  MSGID(DBM0004) MSGF(CEUSRMSG) MSGDTA(&PGM +
                          *CAT '001') TOMSGQ(ERMSGQ)                   ER_R10 */
/************SNDPGMMSG  MSGID(DBM0004) MSGF(ERUSRMSG) MSGDTA(&PGM +
                          *CAT '001') TOMSGQ(ERMSGQ)                  ULX004*/
/**********  SNDPGMMSG  MSGID(DBM0004) MSGF(ERUSRMSG) MSGDTA(&PGM +
                          *CAT '001') TOMSGQ(CADMSGQ)               */                    /*CER001*/
             SNDPGMMSG  MSGID(DBM0004) MSGF(STUSRMSG) MSGDTA(&PGM +
                          *CAT '001') TOMSGQ(MOPERQ)                                      /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)              /*ULX004*/
             CHGVAR     VAR(&RETURN) VALUE('Y')
 
 EOJ:        RCLRSC     LVL(*)
             RCLACTGRP  ACTGRP(*ELIGIBLE)                           /*ULX046*/
             DLTOVR     FILE(*ALL)                                 /* ERL438 */
 ENDPGM:     ENDPGM
