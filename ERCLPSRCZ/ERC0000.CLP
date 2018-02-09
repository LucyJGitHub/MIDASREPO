/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas European Reporting - SETUP files')              */
/*********************************************************************/
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING - LUXEMBOURG                  */
/*                                                                  */
/*     ERC0000  - SETUP European Reporting Files                    */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG10196           Date 28Jan06              */
/*                      BUG10108           Date 25Jan06              */
/*                      CER001             Date 25Apr05              */
/*                      ULX024             Date 03Sep99              */
/*                      ULX012             Date 21Aug98              */
/*                      ULX011           Date     14May98           */
/*                      ULX004           DATE     24FEB97           */
/*                      ULU001           DATE     28AUG95           */
/*                      ER_R10           DATE     18OCT94           */
/*                      ERL370           DATE     11MAY95           */
/*                      L1RAT ADI        DATE     23APR92           */
/*                      64053  DT        DATE     07DEC93           */
/*                      ERL371 TLI       DATE     14OCT93           */
/*                      ER0336 TLI       DATE     04MAY93           */
/*                      ERL015           DATE     29DEC92           */
/*                      ER0141           DATE     29DEC92           */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       BUG10196 - Deal Type/Sub Type DB Error                      */
/*       BUG10108 - Failed during switching off                      */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     ULX024 - Trade Innovation/CSSF Reporting Interface           */
/*     ULX012 - Guarantees and Collateral Management enhancements   */
/*     ULX011 - IML Circular 97/138                                 */
/*     ULX004 - Capital adequacy                                    */
/*               Create CAD setup in XLIB                           */
/*               Add feature ULX004 in SCSARDPD to automatise       */
/*               set ON of CAD if ULU001 installed                  */
/*     ULU001 - IML IS A FEATURE IN R10                             */
/*     ER_R10 - EUROPEAN REPORTING - LUXEMBOURG UPGRADE IN R10      */
/*            - SUPPRESS L1RAT AS R10 IS STILL IN STONE LEVEL       */
/*            - ADD SD0090X6/CL0030X6                               */
/*            - PGM REATYP REDUNDANT  (PGM MERGED INTO RE3271X6)    */
/*     ERL370 - BOOK CODE / INVESTMENT TYPE DEVELOPMENT             */
/*     L1RAT  - NEW L1BGIN PROCEDURE                                */
/*     64053  - SETUP OF EUROPEAN REPORTING MODULE IS NOT COMPLETE  */
/*     ERL371 - IML 1.4 DEVELOPMENT                                 */
/*     ER0336 - CALL NEW PROGRAMS FOR NEW EXTENSIONS FILE           */
/*     ERL015 - SETUP GUARANTOR REPORT NAME IN EXTENSION FILES      */
/*     ER0141 - Setup new extention file PF/FCLTYMX4                */
/*                                                                  */
/*********************************************************************/
/**/
/*>>L1RAT>>*/
/************PGM*/
/************PGM        PARM(&CODE)                                     ER_R10*/
/*********** PGM                                                 ER_R10 ULU001*/
             PGM        PARM(&RTCODE &MODULE)                         /*ULU001*/
 
             DCL        VAR(&RTCODE) TYPE(*CHAR) LEN(7)               /*ULU001*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(1)               /*ULU001*/
             DCL        VAR(&RTCD) TYPE(*DEC) LEN(1 0)                /*ULX004*/
             DCL        VAR(&SWCH) TYPE(*LGL) VALUE('1')              /*ULX004*/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(7)                                    /*CER001*/
             DCL        VAR(&PREFIX)  TYPE(*CHAR) LEN(2)                                  /*CER001*/
/*<<L1RAT<<*/
DCL &MSGDTA *CHAR 52
/*>>L1RAT>>*/
/************DCL        VAR(&TEXT) TYPE(*CHAR) LEN(160)                 ER_R10*/
/************DCL        VAR(&CODE) TYPE(*DEC) LEN(2 0)                  ER_R10*/
/************                                                           ER_R10*/
/************MONMSG     MSGID(CPF0000 MCH0000 CPI0000 RPG0000) +        ER_R10*/
/************             EXEC(GOTO CMDLBL(ERROR))                      ER_R10*/
/************CHGDTAARA  DTAARA(ERRTXT (161 40)) VALUE('European +       ER_R10*/
/************             Returns')                                     ER_R10*/
/************MONMSG     MSGID(CPF0000)                                  ER_R10*/
 
/* CREATE XLIB OBJECTS IF NEEDED                                     */
/**********  CHKOBJ     OBJ(ERJOBD) OBJTYPE(*JOBD)              */                        /*CER001*/
/**********  MONMSG     MSGID(CPF9801) EXEC(CALL PGM(ERSBSD))   */                        /*CER001*/
/**********  CHKOBJ     OBJ(CADJOBD) OBJTYPE(*JOBD)             */                 /*ULX004 CER001*/
/**********  MONMSG     MSGID(CPF9801) EXEC(CALL PGM(CADSBSD))  */                 /*ULX004 CER001*/
/**********  CALL       PGM(SETULX004) PARM(&SWCH &RTCD)        */    /*ULX004*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*CER001*/
             CHGVAR     VAR(&DILIB) VALUE(&PREFIX *CAT 'DILIB')                           /*CER001*/
             CHKOBJ     OBJ(&DILIB/ERSAVF1) OBJTYPE(*FILE)                                /*CER001*/
             MONMSG     MSGID(CPF9801) EXEC(CALL PGM(CADSBSD))                            /*CER001*/
                                                                                        /*BUG10108*/
/** Only proceed with the initialisation if mode is '1' or '2' */                       /*BUG10108*/
                                                                                        /*BUG10108*/
             IF         COND(&MODULE *EQ '3') THEN(DO)                                  /*BUG10108*/
             GOTO       CMDLBL(MODE3)                                                   /*BUG10108*/
             ENDDO                                                                      /*BUG10108*/
                                                                      /*ULX024*/
/* Call Setup pgm ERLU13WG to setup PF/ERTIPCPD                       /*ULX024*/
             CALL       PGM(ERLU13WG)                                 /*ULX024*/
                                                                      /*ULX024*/
/* Add Trigger on Work file */                                        /*ULX024*/
             ADDPFTRG   FILE(ERTIPTPP) TRGTIME(*AFTER) +
                          TRGEVENT(*INSERT) PGM(ERLU13TG) +
                          RPLTRG(*YES)                                /*ULX024*/
                                                                      /*ULX024*/
/*<<L1RAT<<*/
 
             CHGJOB     SWS(00000000)
/* Create local data area                                            */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Local data area')
             MONMSG CPF0000
/*                                                                   */
 /* Set up Statutory Return Flag AND set up ERSTAT */
                                CALL ER0000
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ERROR))
 
 
CALL ER9100WG
 
CALL ERLU30WG
CALL ERLU40WG
CALL ERLU91WG
 
CALL ERDWNDWGLU
CALL CADWNDWGLU                                                    /* ULX004 */
OVRDBF     FILE(SDECOSPD) TOFILE(SDECOSLXPD)
CALL SDECOSWGLU
DLTOVR     FILE(SDECOSPD)
CALL SDNCOSWGLU                                                    /*ULX011*/
CALL SDPROSWG
 
CALL ER0530WG                                                      /* ER0141 */
/***CALL LE0020X4  */                                                    /* ER0141 */
/***CALL LE0020X6  */
/***CALL LE0032X6  */
CALL DL0080X6
CALL MM0026X4
CALL MM0026X6
CALL MM0089X6
/* CALL SD0011X6                                                        ULX012*/
CALL SD0011X6   PARM(' ' &MODULE)                                     /*ULX012*/
CALL SD0061X6
CALL SD0252X6
CALL SD0271X6
CALL SD0281X6
 
CALL SE0020X6
/***CALL SE0040X4  */
/***CALL SE0040X6  */
/*CALL CL0040X6                                                       ER_R10 */
CALL SD0021X4
CALL SD0311X4
CALL SD9121X4
 
/***CALL LE0080X6    */                                                  /* ER0336 */
CALL RE3271X6                                                      /* ER0336 */
CALL SD0181X6                                                      /* ER0336 */
CALL SD0311X6                                                      /* ER0336 */
 
CALL ERGURNX6                                                      /* ERL015 */
 
/**CALL*SDCGRP                                                 * ER0336 ER_R10*/
/*64053 BEGIN*/
/* CALL REATYP                                 REDUNDANT                ER_R10*/
 CALL DL0170X6
 CALL SE0070X6
 CHGDTAARA DTAARA(ERSTAT (11 2)) VALUE('YY')
 CHGDTAARA DTAARA(ERSTAT (26 2)) VALUE('YY')
/*64053 END*/
             CALL       PGM(ER0050X)                               /* ERL370 */
 
CALL SD0031X6                                                      /* ERL371 */
/*CALL CL0030X6                                                       ER_R10 */
CALL SD0090X6                                                      /* ER_R10 */
                                                                      /*ULX004*/
/***   Add CAD Setup programs.***/                                    /*ULX004*/
                                                                      /*ULX004*/
CALL SD0331X6   PARM(' ' &MODULE) /***  Setup of SDFOCSX6 file.  ***/ /*ULX004*/
CALL FF0140X6   PARM(' ' &MODULE) /***  Setup of INTYPDX6 file.  ***/ /*ULX004*/
/***CALL SE0050X6   PARM(' ' &MODULE) */ /***  Setup of TRADSDX6 file.  ***/ /*ULX004*/
                                                                      /*ULX004*/
/** Setup Deal Type/Sub Type */                                                         /*BUG10196*/
                                                                                        /*BUG10196*/
CALL FD0652X6                                                                           /*BUG10196*/
                                                                                        /*BUG10196*/
 
/*>>L1RAT>>*/
/**/
/************CHGDTAARA  DTAARA(PRCDTA (&CODE 1)) VALUE('C')             ER_R10*/
/*<<L1RAT<<*/
                                                                                        /*BUG10108*/
/** Process Mode 3 here */                                                              /*BUG10108*/
                                                                                        /*BUG10108*/
 MODE3:                                                                                 /*BUG10108*/
                                                                                        /*BUG10108*/
GOTO EOJ
 
 ERROR:      RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSGDTA)
/**********  SNDPGMMSG  MSGID(DBM0001) MSGF(GBCEUSRMSG) +
                          MSGDTA(&MSGDTA) TOMSGQ(MRUNQ MOPERQ)          ER_R10*/
             SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(00000000)
/*>>L1RAT>>*/
/************IF         COND(&TEXT *EQ ' ') THEN(CHGVAR VAR(&TEXT) +    ER_R10*/
/************             VALUE('General error has occured during +     ER_R10*/
/************             process. Check joblog before trying your +    ER_R10*/
/************             request again.'))                             ER_R10*/
/************CHGDTAARA  DTAARA(PRCDTA (&CODE 1)) VALUE('F')             ER_R10*/
/************CHGDTAARA  DTAARA(ERRTXT (1 160)) VALUE(&TEXT)             ER_R10*/
/*<<L1RAT<<*/
 
EOJ: ENDPGM
