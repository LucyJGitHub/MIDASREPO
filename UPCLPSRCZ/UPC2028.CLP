/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Shell - change CoB components')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC2028 - Shell - change CoB components                     */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK023  *REWRITE   Date 06Dec05              */
/*                      CSM005             Date 21Sep05              */
/*                      CPK018             Date 02Jun04              */
/*                      CUP024             Date 13Jun03              */
/*                      CPK016             Date 18Apr03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      CUP016 *CREATE     Date 26Aug02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CPK023 - No specific library reference for UPSTAT.          */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK018 - MidasPlus packaging.                               */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK016 - Release 5 packaging.                               */
/*       CUP016 - Release 4 enhancements.                            */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL)                                                    /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
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
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
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
                CALL       PGM(SCC0010) PARM('UPC2028' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
             CALL       PGM(UPC0014) PARM(&SBSID)
 
             ?          CHGCOBCMP
             MONMSG     MSGID(CPF6801)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC2028') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
 
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             CALL       PGM(SCC0010) PARM('UPC2028' 'JOBLOG' 'Y')
 
END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
