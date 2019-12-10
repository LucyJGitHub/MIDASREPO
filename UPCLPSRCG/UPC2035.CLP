/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Copy /COPY to specified location')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC2035 - Copy /COPYs to specified location                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD054605           Date 17Oct19              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CPK018             Date 03Mar04              */
/*                      CPK016             Date 16Jun03              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002 *CREATE     Date 16Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054605 - Deliverable Data Split for SDSVALPD              */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK018 - MidasPlus packaging.  Handle Global layer.         */
/*       CPK016 - Release 5 packaging.  Make command more generic.   */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP002 - Introduction of BRIDGE utility                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&TOLIB)                                                   */ /*CPK016*/
/**********  PGM                                                            */ /*CPK016*/ /*CPK018*/
/**********  PGM        PARM(&LAYER)                                        */ /*CPK018*/ /*CUP033*/
             PGM        PARM(&LAYER &SRCSVAL)                                             /*CUP033*/

             DCL        VAR(&SRCSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRCG,UPGSVALDCL*                                        */ /*             */ /*CUP033*/
             DCL        VAR(&PTFSRC) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CPK018*/
/**********  DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)                                */ /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
/**********  DCLF       FILE(UPGSVALJ0) */                                     /*CUP033* *MD054605*/
             DCLF       FILE(UPGSVALJ0) ALWNULL(*YES)                                   /*MD054065*/

/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Create data area /MIDASMSG in QTEMP */                                                 /*CPK015*/
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)                                            /*CPK015*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')                                                      /*CPK015*/

/************DLTF       FILE(QTEMP/FROMLIB)                                            */ /*CPK016*/
/************MONMSG     MSGID(CPF2105)                                                 */ /*CPK016*/

/* Obtain 'From Library' name from BRIDGE ICD file */
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRCG,UPGSVALCL1*                                        */ /*  */ /*CUP024*/ /*CUP033*/

/**********  IF         COND(&PTFSRC *EQ *BLANKS) THEN(DO)                             */ /*CUP033*/

VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             IF         COND(&GISVAL *EQ &SRCSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFSRC) VALUE(&GIVAL)                                  /*CUP033*/
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
                CALL       PGM(SCC0010) PARM('UPC2035' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO

/**Obtain*list*of*files*in*'From*Library'**/ /*                                        */ /*CPK016*/
/************DSPOBJD    OBJ(&PTFSRC/*ALL) OBJTYPE(*FILE) +                             */ /*CPK016*/
/************             OUTPUT(*OUTFILE) OUTFILE(QTEMP/FROMLIB)                      */ /*CPK016*/

/* Perform copy of Source files */
/************CALL       PGM(UPC0035) PARM(&PTFSRC &TOLIB)                              */ /*CPK016*/
/**********  CPYCPYSRC  FROMLIB(&PTFSRC) ??TOLIB()                          */ /*CPK016*/ /*CPK018*/
             CPYCPYSRC  FROMLIB(&PTFSRC) ??TOLIB(*N) LAYER(&LAYER)                        /*CPK018*/
             MONMSG     MSGID(CPF6801)                                                    /*CPK016*/

             GOTO       CMDLBL(END)
 ABNOR:
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC2035') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC2035' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
