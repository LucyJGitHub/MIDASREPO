/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Start subsystem')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC0146 - Start subsystem                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CUP002             Date 27Jul10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK023             Date 06Dec05              */
/*                      CSM005             Date 21Sep05              */
/*                      CPK018             Date 31May04              */
/*                      CUP024             Date 13Jun03              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP002 - Reset MPHAS to stop people signing in.             */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CPK023 - No specific library reference for UPSTAT.          */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK018 - MidasPlus packaging.  Make option re-runnable.     */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&MODE)                                                    */ /*CPK023*/
/**********  PGM                                                            */ /*CPK023*/ /*CUP033*/
             PGM        PARM(&PFXSVAL)                                                    /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
/**********  DCL        VAR(&MODE) TYPE(*CHAR) LEN(4)                                  */ /*CPK023*/
 
             DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
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
 
/**Depending*on*'Mode'*retrieve*system*prefix.**/ /*                                   */ /*CPK023*/
/**********  IF         COND(&MODE *EQ '*UPG') THEN(DO)                                */ /*CPK023*/
/************   RCVF                                                                   */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
/**********  IF         COND(&SBSID *EQ ' ') THEN(DO)                                  */ /*CUP033*/
 
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
/**********     GOTO       CMDLBL(CHECK)                                    */ /*CUP033*/ /*CPK029*/
             ENDDO                                                                        /*CUP033*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('UPC0146' 'ENTER' ' ')
                GOTO       CMDLBL(ENDPGM)
             ENDDO
             CHGVAR     VAR(&PREFIX) VALUE(&SBSID)
/**********  ENDDO                                                                     */ /*CPK023*/
 
/**********  IF         COND(&MODE *EQ '*IMP') THEN(DO)                                */ /*CPK023*/
/************   RCVF                                                                   */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CPK023*/
/**********     IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ') +                  */ /*CPK023*/
/**********                  THEN(DO)                                                  */ /*CPK023*/
/**********        RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                */ /*CPK023*/
/**********        CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                */ /*CPK023*/
/**********        RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                */ /*CPK023*/
/**********        CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                */ /*CPK023*/
/**********        CALL       PGM(SCC0010) PARM('UPC0146' 'ENTER' ' ')                 */ /*CPK023*/
/**********        GOTO       CMDLBL(ENDPGM)                                           */ /*CPK023*/
/**********     ENDDO                                                                  */ /*CPK023*/
/**********     RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                      */ /*CPK023*/
/**********     CHGVAR     VAR(&PREFIX) VALUE(%SST(&UPSTAT 62 2))                      */ /*CPK023*/
/**********     IF         COND(&PREFIX *EQ '  ') THEN(DO)                             */ /*CPK023*/
/**********        CHGVAR     VAR(&PREFIX) VALUE(&SBSID)                               */ /*CPK023*/
/**********     ENDDO                                                                  */ /*CPK023*/
/**********  ENDDO                                                                     */ /*CPK023*/
 
             CALL       PGM(UPC0014) PARM(&PREFIX)                                        /*CUP002*/
 
             CHGVAR     VAR(&XLIB) VALUE(&PREFIX *TCAT 'XLIB')
             CHGVAR     VAR(&SBS) VALUE('M' *TCAT &PREFIX *TCAT 'SBS')
 
/* Attempt to end the subsystem first. */                                                 /*CPK018*/
             ENDSBS     SBS(&SBS) OPTION(*IMMED)                                          /*CPK018*/
             MONMSG     MSGID(CPF1054)                                                    /*CPK018*/
 
             DLYJOB     DLY(60)                                                           /*CUP002*/
             CHGDTAARA  DTAARA(MPHAS) VALUE('A')                                          /*CUP002*/
 
             STRSBS     SBSD(&XLIB/&SBS)
             MONMSG     MSGID(CPF1010)
 
             GOTO       CMDLBL(ENDPGM)
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0146') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC0146' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
