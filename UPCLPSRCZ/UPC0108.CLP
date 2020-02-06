/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Database cross reference - Zone Layer')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0108 - Database cross reference - zone layer             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CUP028             Date 13Sep04              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSC012             Date 23Oct01              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CUP002 *CREATE     Date 16Aug99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CUP028 - Replace UP0108 with UP000108.                      */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CSC012 - Release 4 packaging.  Move DTALIB LFs to DVLIB.    */
/*       CUP002 - Introduce new post-upgrade check                   */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL)                                                    /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NOFILE) TYPE(*CHAR) LEN(1)                                   /*CSC012*/
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
             DCLF       FILE(UPSVALJ0)                                                    /*CUP033*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
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
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CUP033*/
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                      /*CUP033*/
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CUP033*/
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                      /*CUP033*/
                CALL       PGM(SCC0010) PARM('UPC0108' 'ENTER' ' ')                       /*CUP033*/
                GOTO       CMDLBL(END)                                                    /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             CHGVAR     VAR(&DVLIB) VALUE(&SBSID *TCAT 'DVLIB')
             CHGVAR     VAR(&DTALIB) VALUE(&SBSID *TCAT 'DTALIB')
 
/* Create user spaces */
             CRTUSRSPC  USRSPC(QTEMP/DBR) DELETE(*YES)
 
/* Display file description for logical files in DV and DTA libs.    */
             DSPFD      FILE(&DVLIB/*ALL) TYPE(*ACCPTH) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPFDAPOF)
/************MONMSG     MSGID(CPF3012)                                                 */ /*CSC012*/
             MONMSG     MSGID(CPF3012) EXEC(DO)                                           /*CSC012*/
                CHGVAR     VAR(&NOFILE) VALUE('Y')                                        /*CSC012*/
             ENDDO                                                                        /*CSC012*/
             DSPFD      FILE(&DTALIB/*ALL) TYPE(*ACCPTH) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPFDAPOF) +
                          OUTMBR(*FIRST *ADD)
             MONMSG     MSGID(CPF3012) EXEC(DO)
                IF         COND(&NOFILE *NE 'Y') THEN(DO)                                 /*CSC012*/
                   DSPFD      FILE(QAFDACCP) TYPE(*MBR) OUTPUT(*OUTFILE) +
                                OUTFILE(QTEMP/UPFDAPOF)
                   CLRPFM     FILE(QTEMP/UPFDAPOF)
                ENDDO                                                                     /*CSC012*/
             ENDDO
 
/* Call program to retrieve data from user space and produce report */
/******      CALL       PGM(UP0108) PARM(&SBSID &RETURN)            */                    /*CUP028*/
             CALL       PGM(UP000108) PARM(&SBSID '*ZONE  ' &RETURN)                      /*CUP028*/
             IF         COND(&RETURN *NE ' ') THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGSPLFA   FILE(UP0108P1) SPLNBR(*LAST) USRDTA('UP0108')                     /*CUP028*/
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0108') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC0108' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
