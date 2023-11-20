/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP OTU Rvw/Conf/Proc *ALL Action Files')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC80026 - OTU Rvw/Conf?Proc *All Action Files              */
/*                                                                   */
/*       Function: This program handles deliverable data similar to  */
/*                 UPC8002.                                          */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. MD061880           Date 14Sep23              */
/*       Prev Amend No. CUP044   *CREATE   Date 22May22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD061880 - Include Fix package installation                 */
/*       CUP044 - One Touch Bridge Automation Changes - Release/     */
/*                Patch Upgrade                                      */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&MODE)                                                    */ /*CUP033*/
/**********  PGM        PARM(&MODE &PFXSVAL &DTASVAL)                       */ /*CUP033*/ /*CUP021*/
/**********  PGM        PARM(&MODE &PFXSVAL &BRGSVAL &LAYER)                    */ /*CUP021 CUP040*/
             PGM        PARM(&MODE &PFXSVAL &BRGSVAL &BRGDTASV &LAYER)                    /*CUP040*/

/* Mode can be of three types: */
/*  *REVIEW                    */
/*  *CONFLICT                  */
/*  *PROCESS                   */

             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**********  DCL        VAR(&DTASVAL) TYPE(*CHAR) LEN(20)                   */ /*CUP033*/ /*CUP021*/
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP021*/
             DCL        VAR(&BRGDTASV) TYPE(*CHAR) LEN(20)                                /*CUP040*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CUP021*/

             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&PTFDTA) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BRGDTALIB) TYPE(*CHAR) LEN(10)                               /*CUP040*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                     */ /*CUP022*/ /*CUP021*/

             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&SAVLIB) TYPE(*CHAR) LEN(10)                                /*MD054955*/
             DCL        VAR(&NBRCD) TYPE(*DEC) LEN(10 0)                                /*MD059732*/

/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
/**********  DCLF       FILE(UPSVALJ0) */                                      /*CUP033* *MD054605*/
             DCLF       FILE(UPSVALJ0) ALWNULL(*YES)                                    /*MD054605*/

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
             IF         COND(&GISVAL *EQ &BRGDTASV) THEN(DO)                              /*CUP040*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP040*/
/* Simply skip process if system value is blank */                                      /*MD061880*/
                GOTO       CMDLBL(END)                                                  /*MD061880*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP040*/
                ENDDO                                                                     /*CUP040*/
                ELSE       CMD(DO)                                                        /*CUP040*/
                   CHGVAR     VAR(&BRGDTALIB) VALUE(&GIVAL)                               /*CUP040*/
                ENDDO                                                                     /*CUP040*/
             ENDDO                                                                        /*CUP040*/

             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/

 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
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
/**********  CALL       PGM(UPC8003) PARM(&MODE)                                          /*CUP021*/
             CALL       PGM(UPC8003) PARM(&MODE &BRGDTALIB)                               /*CUP040*/
             DLTOVR     FILE(UPDLVCPD)                                                    /*CUP021*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
                GOTO       CMDLBL(END)
             ENDDO

/* Copy UPDLVCPD file to temporary version for Deliverable Data Split */                /*MD054605*/
             DLTF       FILE(QTEMP/UPDLVCQT)                                            /*MD054605*/
             MONMSG     MSGID(CPF0000)                                                  /*MD054605*/
             CPYF       FROMFILE(&PTFDTA/UPDLVCPD) +
                          TOFILE(QTEMP/UPDLVCQT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AUMBTP *EQ +
                          'DDSDATA') (*AND AUDTYP *EQ 'I') (*AND +
                          AUDTLB *EQ &LAYER))                                           /*MD054605*/
                                                                                        /*MD059732*/
/* Clear conflict summary file used for report */                                       /*MD059732*/
             IF         COND(&MODE *EQ '*CONFLICT') THEN(DO)                            /*MD059732*/
             CLRPFM     FILE(UPCFTNTD)                                                  /*MD059732*/
             MONMSG     MSGID(CPF0000)                                                  /*MD059732*/
             ENDDO                                                                      /*MD059732*/
                                                                                        /*MD054605*/
/**********  CALL       PGM(UPC008004) PARM(&MODE &BRGDTALIB) */              /*MD054605* MD054955*/
             CHGVAR     VAR(&SAVLIB) VALUE('#.' *TCAT &SBSID +
                             *TCAT 'DMLIB')                                             /*MD054955*/
             CALL       PGM(UPC008004) PARM(&MODE &BRGDTALIB &SAVLIB)                   /*MD054955*/
/**********  DLTOVR     FILE(UPDLVCPD) */                                    /*MD054605* *MD055056*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
                GOTO       CMDLBL(END)                                                  /*MD054605*/
             ENDDO                                                                      /*MD054605*/
                                                                                        /*MD054605*/
/* Generate conflict summary report */                                                  /*MD059732*/
             IF         COND(&MODE *EQ '*CONFLICT') THEN(DO)                            /*MD059732*/
             CALL       PGM(UP4033) PARM(&LAYER)                                        /*MD059732*/
             RTVMBRD    FILE(UPCFTNTD) NBRCURRCD(&NBRCD)                                /*MD059732*/
             IF         COND(&NBRCD *NE 0) THEN(DO)                                     /*MD059732*/
                CHGJOB     SWS(XX1XXXXX)
                GOTO       CMDLBL(END)                                                  /*MD059732*/
             ENDDO                                                                      /*MD059732*/
             ENDDO                                                                      /*MD059732*/
                                                                                        /*MD059732*/
/* If *PROCESS, then run VALD */
             IF         COND(&MODE *EQ '*PROCESS') THEN(DO)
             CALL       PGM(UPC20256) PARM('BrgMidasSystemPrefix')
/* and COB optimization */
             CALL       PGM(SC001002)
             ENDDO

             GOTO       CMDLBL(END)

ABNOR:
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
