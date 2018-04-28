/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Shell for calling pgms. for upgrade zone')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC2100 - Shell for calling programs for upgrade            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CSM010             Date 22Jun07              */
/*       Prev Amend No. CUP037             Date 17May07              */
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CPK030             Date 08Dec04              */
/*                      CPK020             Date 17Aug04              */
/*                      CPK018             Date 23Feb04              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 01Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSM010 - Applied by CUP037.                                 */
/*       CUP037 - Override to zone system values for global          */
/*                programs.                                          */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK030 - Allow EXEs to be called before or after upgrade.   */
/*       CPK020 - Check for errors is incorrect.                     */
/*       CPK018 - MidasPlus packaging.  Handle Global layer.         */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP030*/
/**********  PGM        PARM(&MODE)                                         */ /*CUP030*/ /*CUP033*/
             PGM        PARM(&MODE &PFXSVAL &BRGSVAL)                                     /*CUP033*/
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)                                     /*CUP030*/
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPSTATPOS) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
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
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CUP033*/
/**********               THEN(DO)                                                     */ /*CUP033*/
 
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
 
             IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)                                  /*CUP033*/
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
                CALL       PGM(SCC0010) PARM('UPC2100' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
             CALL       PGM(UPC0014) PARM(&SBSID)
/**CHKLIBLE:                                                                           */ /*CPK018*/
/**********  CHGVAR     VAR(&RETURN) VALUE(' ')                                        */ /*CPK018*/
/**********  CHKLIBLE   LIBS(&PTFUPG) RETURN(&RETURN)                                  */ /*CPK018*/
/**********  IF         COND(&RETURN *EQ 'F') THEN(DO)                                 */ /*CPK018*/
/**********     EDTLIBL                                                                */ /*CPK018*/
/**********     GOTO CHKLIBLE                                                          */ /*CPK018*/
/**********  ENDDO                                                                     */ /*CPK018*/
 
             RMVLIBLE   LIB(&PTFUPG)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(&PTFUPG) POSITION(*FIRST)
 
             OVRDBF     FILE(UPGSVALJ0) TOFILE(UPSVALJ0) OVRSCOPE(*JOB)                   /*CUP037*/
 
/* Call program to run upgrade programs */
/**********  CALL       PGM(UPC9900) PARM(&RETURN)                                     */ /*CUP030*/
             CALL       PGM(UPC9900) PARM(&MODE &RETURN)                                  /*CUP030*/
/*If the program ended abnormally then display general message */
             IF         COND(&RETURN *NE ' ') THEN(DO)
                RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                        MSGDTA('UPC9900') MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('UPC9900' 'JOBLOG' 'Y')
                GOTO       CMDLBL(END)
             ENDDO
/*If the program encountered errors then display specific messages */
             CHGVAR     VAR(&UPSTATPOS) VALUE(0)
/**********  CALL       PGM(UPC0015) PARM('UPDLVCLH' 'UPDLVCL8' +                      */ /*CPK018*/
/**********            'UPC9900' &UPSTATPOS &RETURN)                                   */ /*CPK018*/
/**********  CALL       PGM(UPC0015) PARM('UPDLVCLH' 'UPC9900' +                       */ /*CPK020*/
/**********               &UPSTATPOS &RETURN)                               */ /*CPK018*/ /*CPK020*/
             CALL       PGM(UPC0015) PARM('UPDLVCL8' 'UPC9900' +
                          &UPSTATPOS &RETURN)                                             /*CPK020*/
             IF         COND(&RETURN *NE ' ') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC2100') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC2100' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             DLTOVR     FILE(UPGSVALJ0) LVL(*JOB)                                         /*CUP037*/
 
             ENDPGM
