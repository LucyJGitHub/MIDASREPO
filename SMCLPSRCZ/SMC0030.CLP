/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Copy JNSTAT')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0030 - Copy JNSTAT                                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP037             Date 03Apr07              */
/*       Prev Amend No. CUP034             Date 24Jan07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 30Jun06              */
/*                      CPK023             Date 25Nov05              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CSC020             Date 29Dec04              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP037 - Update previous run date field in JNSTAT.          */
/*       CUP034 - Reduce size of implementation library.             */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CPK023 - Initialise next receiver value                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CSC020 - MidasPlus changes for journaling.                  */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL &OPFXSVAL)                                          /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/
 
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
/**********  DCL        VAR(&TOSBSID) TYPE(*CHAR) LEN(2)                               */ /*CSM003*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&FMJLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOJLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)                                   /*CUP037*/
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CSM003*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             DCLF       FILE(UPSVALJ0)                                                    /*CUP033*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CSM003*/ /*CUP033*/
 
/* Check if all relevant fields have been entered in ICD */
/**********  IF         COND(&SBSID *EQ ' ' *OR &PTFUPG *EQ ' ') +                     */ /*CSM003*/
/**********               THEN(DO)                                                     */ /*CSM003*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &PTFUPG *EQ ' ' *OR +                  */ /*CUP033*/
/**********               &OLDSBSID *EQ ' ') THEN(DO)                       */ /*CSM003*/ /*CUP033*/
 
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &PFXSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&SBSID) VALUE(&GIVAL)                                   /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &OPFXSVAL) THEN(DO)                              /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&OLDSBSID) VALUE(&GIVAL)                                /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/* Set up messages for Midas Information Screen  */
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC0030' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Set up library list. */                                                                /*CUP034*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP034*/
 
/**Retrieve*"to"*library*prefix*from*data*area*UPSTAT**/ /*                            */ /*CSM003*/
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CSM003*/
/**********  CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 62 2))                        */ /*CSM003*/
 
/**********  CHGVAR     VAR(&FMJLIB) VALUE(&SBSID *TCAT 'JLIB')                        */ /*CSM003*/
/**********  CHGVAR     VAR(&TOJLIB) VALUE(&TOSBSID *TCAT 'JLIB')                      */ /*CSM003*/
             CHGVAR     VAR(&FMJLIB) VALUE(&OLDSBSID *TCAT 'JLIB')                        /*CSM003*/
             CHGVAR     VAR(&TOJLIB) VALUE(&SBSID *TCAT 'JLIB')                           /*CSM003*/
             CHGVAR     VAR(&DMLIB) VALUE(&SBSID *TCAT 'DMLIB')                           /*CUP037*/
 
             ?          CPYDTAARA ??FMDTAARA(&FMJLIB/JNSTAT) +
                          ??TODTAARA(&TOJLIB/JNSTAT)
             MONMSG     MSGID(CPF6801)
 
/**********  CHGDTAARA  DTAARA(&TOJLIB/JNSTAT (1 8)) VALUE('ICRCV001')                 */ /*CSC020*/
             CHGDTAARA  DTAARA(&TOJLIB/JNSTAT (1 10)) VALUE('IR00000001')                 /*CSC020*/
/**********  CHGDTAARA  DTAARA(&TOJLIB/JNSTAT (147 2)) VALUE(&TOSBSID)                 */ /*CSM003*/
             CHGDTAARA  DTAARA(&TOJLIB/JNSTAT (147 2)) VALUE(&SBSID)                      /*CSM003*/
                                                                                          /*CPK023*/
             /* Next Receiver to Save */                                                  /*CPK023*/
             CHGDTAARA  DTAARA(&TOJLIB/JNSTAT (11 20)) VALUE('IR00000001')                /*CPK023*/
 
/* Change previous run date field in JNSTAT; override to correct version */               /*CUP037*/
/*  of SDBANKPD.                                                         */               /*CUP037*/
             OVRDBF     FILE(SDBANKPD) TOFILE(&DMLIB/SDBANKPD) +
                          OVRSCOPE(*JOB)                                                  /*CUP037*/
             CALL       PGM(SM000004)                                                     /*CUP037*/
             DLTOVR     FILE(SDBANKPD) LVL(*JOB)                                          /*CUP037*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CUP037*/
                GOTO       CMDLBL(ABNOR)                                                  /*CUP037*/
             ENDDO                                                                        /*CUP037*/
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC0030') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC0030' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
