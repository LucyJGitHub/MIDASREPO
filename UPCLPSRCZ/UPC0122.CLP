/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Change system job descs. JOBQs and OUTQs')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0122 - Change system's job descriptions                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CPK017             Date 13Jun03              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 29Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CUP013             Date 10Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK017 - Release 5 packaging.  Change job descriptiom       */
/*                user too.                                          */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CPK014 - Release 4 packaging.  Add RCVF.                    */
/*       CUP013 - New program to change libraries for a job          */
/*                 description's job queue and output queue.         */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL)                                                    /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                              */ /*CUP033*/
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                                    /*CPK017*/
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
 
/************RCVF                                                           */ /*CPK014*/ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
 
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
                ?    SYSTEMID
                MONMSG     MSGID(CPF6801) EXEC(DO)                                        /*CUP033*/
                   GOTO       CMDLBL(END)                                                 /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                RTVDTAARA  DTAARA(QTEMP/SYSID) RTNVAR(&SBSID)
             ENDDO
 
/* Set up library list */
             CALL       PGM(UPC0014) PARM(&SBSID)
 
             CHGVAR     VAR(&XLIB) VALUE(&SBSID *TCAT 'XLIB')
             CHGVAR     VAR(&USER) VALUE(&SBSID *TCAT 'OWNER')                            /*CPK017*/
/* Check that user exists. */                                                             /*CPK017*/
             CHKOBJ     OBJ(&USER) OBJTYPE(*USRPRF)                                       /*CPK017*/
 
/* Display list of all job descriptions in system XLIB. */
             DSPOBJD    OBJ(&XLIB/*ALL) OBJTYPE(*JOBD) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPJOBDOF)
 
/* Call program to update job descriptions. */
/**********  CALL       PGM(UPC0123) PARM(&ERROR)                                      */ /*CPK017*/
             CALL       PGM(UPC0123) PARM(&USER &ERROR)                                   /*CPK017*/
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                SNDPGMMSG  MSGID(UPM0002) MSGF(UTMSGF) +
                          MSGDTA('UPC0122') MSGTYPE(*ESCAPE)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
