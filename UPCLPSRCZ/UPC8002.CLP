/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Rvw/Conf/Proc *ALL Action Files - shell')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC8002 - Review/Conflict/Process *ALL Action Files         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CUP021             Date 07Feb11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CUP022             Date 22Apr04              */
/*                      CUP024             Date 13Jun03              */
/*                      CUP020  *CREATE    Date 03Jan03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP021 - Rewrite of Action File processing.                 */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CUP022 - Call UPC8003 with &DPLIB instead of &SBSID.        */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CUP020 - Additional changes for Action Files                */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&MODE)                                                    */ /*CUP033*/
/**********  PGM        PARM(&MODE &PFXSVAL &DTASVAL)                       */ /*CUP033*/ /*CUP021*/
             PGM        PARM(&MODE &PFXSVAL &BRGSVAL &LAYER)                              /*CUP021*/
 
/* Mode can be of three types: */
/*  *REVIEW                    */
/*  *CONFLICT                  */
/*  *PROCESS                   */
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**********  DCL        VAR(&DTASVAL) TYPE(*CHAR) LEN(20)                   */ /*CUP033*/ /*CUP021*/
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP021*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CUP021*/
 
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&PTFDTA) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                     */ /*CUP022*/ /*CUP021*/
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
             DCLF       FILE(UPSVALJ0)                                                    /*CUP033*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/* Create temporary file to hold error messages. */                                       /*CUP021*/
             DLTF       FILE(QTEMP/UPERRMQT)                                              /*CUP021*/
             MONMSG     MSGID(CPF2105)                                                    /*CUP021*/
             CRTPF      FILE(QTEMP/UPERRMQT) RCDLEN(100) +
                          TEXT('Temporary file for holding error +
                          messages')                                                      /*CUP021*/
 
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
/**********  IF         COND(&PTFDTA *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CUP033*/
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
 
/**********  IF         COND(&GISVAL *EQ &DTASVAL) THEN(DO)                 */ /*CUP033*/ /*CUP021*/
             IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                               /*CUP021*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
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
                CALL       PGM(SCC0010) PARM('UPC8002' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
             CALL       PGM(UPC0014) PARM(&SBSID)
 
/**********  CHGVAR     VAR(&DPLIB) VALUE(&SBSID *TCAT 'DPLIB')             */ /*CUP022*/ /*CUP021*/
 
/* Copy UPDLVCPD file to temporary version. */                                            /*CUP021*/
             DLTF       FILE(QTEMP/UPDLVCQT)                                              /*CUP021*/
             MONMSG     MSGID(CPF0000)                                                    /*CUP021*/
             CPYF       FROMFILE(&PTFDTA/UPDLVCPD) +
                          TOFILE(QTEMP/UPDLVCQT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AUMBTP *EQ +
                          'DATA') (*AND AUDTYP *EQ 'I') (*AND +
                          AUDTLB *EQ &LAYER))                                             /*CUP021*/
 
/* Call program to check Action Files. */
/**********  OVRDBF     FILE(UPGPACTFPD) TOFILE(UPACTFPD) +                            */ /*CUP021*/
/**********               OVRSCOPE(*JOB)                                    */ /*CUP022*/ /*CUP021*/
/*****       CALL       PGM(UPC8003) PARM(&MODE &PTFDTA &SBSID)                           /*CUP022*/
 
/**********  CALL       PGM(UPC8003) PARM(&MODE &PTFDTA &DPLIB)             */ /*CUP022*/ /*CUP021*/
/**********  DLTOVR     FILE(UPGPACTFPD) LVL(*JOB)                          */ /*CUP022*/ /*CUP021*/
/**********  MONMSG     MSGID(CPF0000)                                      */ /*CUP022*/ /*CUP021*/
             OVRDBF     FILE(UPDLVCPD) TOFILE(QTEMP/UPDLVCQT)                             /*CUP021*/
             CALL       PGM(UPC8003) PARM(&MODE)                                          /*CUP021*/
             DLTOVR     FILE(UPDLVCPD)                                                    /*CUP021*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC8003') MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('UPC8003' 'JOBLOG' 'Y')
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC8002') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC8002' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
