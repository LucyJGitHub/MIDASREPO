/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Journal unjournalled files')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2465 - Journal Unjournalled Files                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6546            Date 25Apr05              */
/*                      CSC018             Date 10Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009 *CREATE     Date 21Jun00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6546 - Check SCNJRNL0 in calling program SCC2464,        */
/*                 Remove RCVF loop from this program.               */
/*               - Locking problem. Allocate object before trying    */
/*                 to start journalling                              */
/*       CSC018 - Change program to use the SCNJRNL0 logical         */
/*       CCB009 - Journal files throughout close of business.        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE &LIB)
 
/*/COPY WNCPYSRC,SCC2465INT                                          */
 
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSGCLR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**********  DCLF       FILE(SCNJRNPD) */                                                 /*CSC018*/
/**********  DCLF       FILE(SCNJRNL0) */                                     /*CSC018*/ /*BUG6546*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC2465MPS                                          */
 
/**Check*to*see*if*the*file*should*be*journalled*and*if*so*journal*it**/                 /*BUG6546*/
 
/*RCVF:****   RCVF                                                                       /*BUG6546*/
/**********  MONMSG     MSGID(CPF0864) EXEC(DO)                                          /*BUG6546*/
                ALCOBJ     OBJ((&FILE *FILE *EXCL)) WAIT(0)                              /*BUG6546*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                                       /*BUG6546*/
                   CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)                               /*BUG6546*/
                   CHGVAR     VAR(&MESSAGE) VALUE('Unable to allocate file +
                             ' *CAT &FILE *BCAT 'in ' *cat &LIB)                         /*BUG6546*/
                   SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2465)                        /*BUG6546*/
/* Multilanguage compilation file may well have no members and cannot allocate.          /*BUG6546*/
                   IF         COND(&FILE *EQ 'MLDDSSRC') THEN(DO)                        /*BUG6546*/
                      GOTO       CMDLBL(END)                                             /*BUG6546*/
                   ENDDO                                                                 /*BUG6546*/
                   ELSE       CMD(DO)                                                    /*BUG6546*/
                      GOTO       CMDLBL(ABNOR)                                           /*BUG6546*/
                   ENDDO                                                                 /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
 
                STRJRNPF   FILE(&FILE) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)
                CHGVAR     VAR(&MESSAGE) VALUE('File ' *CAT &FILE *BCAT +
                             'journalled in library ' *CAT &LIB)
                SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2465)
                DLCOBJ     OBJ((&FILE *FILE *EXCL))                                      /*BUG6546*/
                MONMSG     MSGID(CPF0000)                                                /*BUG6546*/
                GOTO       CMDLBL(END)
/**********  ENDDO                                                                       /*BUG6546*/
 
/**********  IF         COND((&NJFILE *EQ &FILE) *AND (&NJACTV *EQ +                     /*BUG6546*/
/**********               'Y')) THEN(DO)                                                 /*BUG6546*/
/**********     GOTO       CMDLBL(END)                                                   /*BUG6546*/
/**********  ENDDO                                                                       /*BUG6546*/
 
/*/COPY WNCPYSRC,SCC2465MPE                                          */
 
/**********  GOTO       CMDLBL(RCVF)                                                     /*BUG6546*/
 
 ABNOR:
/*/COPY WNCPYSRC,SCC2465ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC2465 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)
             CHGVAR     VAR(&MESSAGE) VALUE('Program SCC2465 ended +
                          abnormally - see job log')
             SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2465)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCC2465END                                          */
 
             RETURN
 
             ENDPGM
