/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Create driving file')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0010 - Create Driving file                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSM005             Date 21Sep05              */
/*                      CPK020             Date 29Jul04              */
/*                      CPK019  *MOVED     Date 29Jun04              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CUP006             Date 21Dec99              */
/*                      164905             Date 30Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 02Aug99              */
/*                      CUP002             Date 15Apr99              */
/*                      CUP001 *CREATE     Date 23Jul98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK020 - Handle deliverable data.                           */
/*       CPK019 - Use global system values and move to global layer. */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CUP006 - New program called that tests for both shared      */
/*                formats and logicals being delivered.              */
/*       164905 - Pgm loops if error message received in ABNOR       */
/*                processing - add MONMSG for each command in ABNOR. */
/*       CPK009 - Call program to handle shared format files.        */
/*       CUP002 - Add prompt to prevent people creating driving      */
/*                 file inadvertently.                               */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&BRGSVAL &SRCSVAL &DTASVAL)                                  /*CUP033*/
 
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&SRCSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&DTASVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */        /*CUP024*/ /*CPK019*/
/**COPY*UPCPYSRCG,UPGSVALDCL*                                        */ /*  */ /*CPK019*/ /*CUP033*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&PTFSRC) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&PTFDTA) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1) VALUE('N')    /*CUP002*/
/**********  DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)                     */ /*CUP006*/ /*CUP033*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
             DCLF       FILE(UPGSVALJ0)                                                   /*CUP033*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create data area /MIDASMSG in QTEMP */                             /*CUP002*/
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)                        /*CUP002*/
             MONMSG     MSGID(CPF0000)                                /*CUP002*/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')                                  /*CUP002*/
                                                                      /*CUP002*/
/* Send message to screen to ask if user really wants to run this */  /*CUP002*/
/*  option                                                        */  /*CUP002*/
             RTVMSG     MSGID(UPM0025) MSGF(UTMSGF) MSG(&MESSAGE)     /*CUP002*/
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)     /*CUP002*/
             CALL       PGM(SCC0010) PARM('UPC0010' 'OPTION' &REPLY1) /*CUP002*/
             IF         COND(&REPLY1 *EQ 'N') THEN(DO)                /*CUP002*/
                GOTO       CMDLBL(END)                                /*CUP002*/
             ENDDO                                                    /*CUP002*/
                                                                      /*CUP002*/
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */        /*CUP024*/ /*CPK019*/
/**COPY*UPCPYSRCG,UPGSVALCL1*                                        */ /*  */ /*CPK019*/ /*CUP033*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&PTFSRC *EQ ' ' *OR &PTFUPG *EQ ' ' *OR +                 */ /*CPK019*/
/**********               &SBSID *EQ ' ') THEN(DO)                                     */ /*CPK019*/
/**********  IF         COND(&PTFSRC *EQ ' ' *OR &PTFUPG *EQ ' ') +                    */ /*CUP033*/
/**********               THEN(DO)                                          */ /*CPK019*/ /*CUP033*/
/* Set up messages for Midas Information Screen  */
 
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &SRCSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFSRC) VALUE(&GIVAL)                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &DTASVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&PTFDTA) VALUE(' ')                                     /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFDTA) VALUE(&GIVAL)                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
/************   CALL       PGM(SCC0010) PARM('UPC2000' 'ENTER' ' ')   /*CUP002*/
                CALL       PGM(SCC0010) PARM('UPC0010' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/**********  CALL       PGM(UPC0014) PARM(&SBSID)                                      */ /*CPK019*/
 
/*CHKLIBLE:*                                                                */ /*CUP006*/ /*CPK019*/
/**********  CHGVAR     VAR(&RETURN) VALUE(' ')                             */ /*CUP006*/ /*CPK019*/
/**********  CHKLIBLE   LIBS(&PTFUPG) RETURN(&RETURN)                       */ /*CUP006*/ /*CPK019*/
/**********  IF         COND(&RETURN *EQ 'F') THEN(DO)                      */ /*CUP006*/ /*CPK019*/
/**********     EDTLIBL                                                     */ /*CUP006*/ /*CPK019*/
/**********     GOTO CHKLIBLE                                               */ /*CUP006*/ /*CPK019*/
/**********  ENDDO                                                          */ /*CUP006*/ /*CPK019*/
                                                                                          /*CUP006*/
             RMVLIBLE   LIB(&PTFUPG)                                                      /*CUP006*/
             MONMSG     MSGID(CPF0000)                                                    /*CUP006*/
             ADDLIBLE   LIB(&PTFUPG) POSITION(*FIRST)                                     /*CUP006*/
 
/**********  CRTDLVLST  SRC(&PTFSRC/*ALL) DLVLIB(&PTFUPG) +                            */ /*CPK020*/
/**********               DFTLIB(*MPLIB) CRTOPT(*REPLACE)                              */ /*CPK020*/
             IF         COND(&PTFDTA *EQ ' ') THEN(DO)                                    /*CPK020*/
                CRTDLVLST  SRC(&PTFSRC/*ALL) DLVLIB(&PTFUPG) +
                             CRTOPT(*REPLACE)                                             /*CPK020*/
             ENDDO                                                                        /*CPK020*/
             IF         COND(&PTFDTA *NE ' ') THEN(DO)                                    /*CPK020*/
                CRTDLVLST  SRC(&PTFSRC/*ALL) DLVLIB(&PTFUPG) +
                             DTA(&PTFDTA) CRTOPT(*REPLACE)                                /*CPK020*/
             ENDDO                                                                        /*CPK020*/
 
/* Call program to put priority up for shared format files and check */                   /*CPK009*/
/*  that all such files have been delivered.                         */                   /*CPK009*/
/************OVRDBF     FILE(UPDLVCL0) TOFILE(&PTFUPG/UPDLVCL0)                /*CPK009*/ /*CUP006*/
/************CALL       PGM(UP0092)                                            /*CPK009*/ /*CUP006*/
/**********  CALL       PGM(UP0093)                                         */ /*CUP006*/ /*CPK020*/
             CALL       PGM(UPC0093)                                                      /*CPK020*/
/************DLTOVR     FILE(UPDLVCL0)                                         /*CPK009*/ /*CUP006*/
                                                                                          /*CPK009*/
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0010') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*164905*/
/************MONMSG     MSGID(CPF0000)                                /*164905*/
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*164905*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*164905*/
             CALL       PGM(SCC0010) PARM('UPC0010' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*164905*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*164905*/
 
             ENDPGM
