/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Files not to be journalled in a library')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2462 - Files Not to be Journalled in a Library           */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. AR1019279          Date 21Sep12              */
/*       Prev Amend No. 248757             Date 27Jun07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG7935            Date 17Aug05              */
/*                      CUP099             Date 10Jun05              */
/*                      BUG6546            Date 13Apr05              */
/*                      CSC018             DATE 10Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009 *CREATE     DATE 01Jun00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1019279 - Reinstate programs SCC2462 and SCC2468 in BF.   */
/*       248757 - XREH* files may not exist.                         */
/*       BUG7935- Problems with BUG6546.                             */
/*       CUP099 - Message queue SCC2465 may not always be present.   */
/*       BUG6546 - Locking problem. Allocate object before trying    */
/*                 to start journalling                              */
/*       CSC018 - Change program to use the SCNJRNL0 logical         */
/*       CCB009 - Journal files throughout close of business.        */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCC2462INT                                          */
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)                                    /*BUG6546*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                                /*BUG6546*/
             DCL        VAR(&MSGCLR) TYPE(*CHAR) LEN(50)                                 /*BUG6546*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
/**********  DCLF       FILE(SCNJRNPD) */                                                 /*CSC018*/
             DCLF       FILE(SCNJRNL0)                                                    /*CSC018*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC2462MPS                                          */
 
/* Check if message queue SCC2465 exists. */                                              /*CUP099*/
             CHKOBJ     OBJ(QTEMP/SCC2465) OBJTYPE(*MSGQ)                                 /*CUP099*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CUP099*/
                CRTMSGQ    MSGQ(QTEMP/SCC2465)                                            /*CUP099*/
             ENDDO                                                                        /*CUP099*/
 
/* Read through the file and end journal each file. */
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             IF         COND(&NJACTV *EQ 'Y') THEN(DO)
/* If file does not exists check next ones.                                               /*248757*/
             CHKOBJ     OBJ(&NJFILE) OBJTYPE(*FILE)                                       /*248757*/
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(RCVF))                            /*248757*/
                                                                                          /*248757*/
                ALCOBJ     OBJ((&NJFILE *FILE *EXCL)) WAIT(0)                            /*BUG6546*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                                       /*BUG6546*/
                   CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)                               /*BUG6546*/
                   CHGVAR     VAR(&MESSAGE) VALUE('Unable to allocate file +
                             ' *CAT &NJFILE *BCAT 'in ' *cat &LIB)                       /*BUG6546*/
                   SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2465)                        /*BUG6546*/
/* Multilanguage compilation file may well have no members and cannot allocate.          /*BUG6546*/
                   IF         COND(&NJFILE *EQ 'MLDDSSRC') THEN(DO)                      /*BUG6546*/
                      GOTO       CMDLBL(RCVF)                                            /*BUG6546*/
                   ENDDO                                                                 /*BUG6546*/
                   IF         COND(&NJFILE *EQ 'CBMUTXPD') THEN(DO)                      /*BUG7935*/
                      GOTO       CMDLBL(RCVF)                                            /*BUG7935*/
                   ENDDO                                                                 /*BUG7935*/
                   ELSE       CMD(DO)                                                    /*BUG6546*/
                      GOTO       CMDLBL(ABNOR)                                           /*BUG6546*/
                   ENDDO                                                                 /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                ENDJRNPF   FILE(&NJFILE) JRN(ICJRN)
                MONMSG     MSGID(CPF0000)
                DLCOBJ     OBJ((&NJFILE *FILE *EXCL))                                    /*BUG6546*/
                MONMSG     MSGID(CPF0000)                                                /*BUG6546*/
             ENDDO
 
/*/COPY WNCPYSRC,SCC2462MPE                                          */
 
             GOTO       CMDLBL(RCVF)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC2462ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC2462 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited') 
 
/*/COPY WNCPYSRC,SCC2462END                                          */
 
             ENDPGM
