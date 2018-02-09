/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Journal unjournalled data queues')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2472 - Journal Unjournalled Data Queues                  */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6546            Date 25Apr05              */
/*                      CSC018 *C *CREATE  Date 31May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6546 - Check SCNJRNL2 in calling program SCC2469 and     */
/*                 SCC2471. Remove RCVF loop from this program.      */
/*               - Locking problem. Allocate object before trying    */
/*                 to start journalling                              */
/*       CSC018 - Journaling options for high availability           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DTAQ &LIB)
 
/*/COPY WNCPYSRC,SCC2472INT                                                                       */
 
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSGCLR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCLF       FILE(SCNJRNL2)
/**********  DCLF       FILE(SCNJRNL2) */                                                /*BUG6546*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC2472MPS                                                                       */
 
             CRTMSGQ    MSGQ(QTEMP/SCC2472)
             MONMSG     MSGID(CPF0000)
 
/**Check*to*see*if*the*date*queue*should*be*journalled*and*if*so,                        /*BUG6546*/
/**journal*it.                                                                           /*BUG6546*/
 
/*RCVF:****                                                                              /*BUG6546*/
/**********  RCVF                                                                        /*BUG6546*/
/**********  MONMSG     MSGID(CPF0864) EXEC(DO)                                          /*BUG6546*/
                ALCOBJ     OBJ((&DTAQ *DTAQ *EXCL)) WAIT(0)                              /*BUG6546*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                                       /*BUG6546*/
                   CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)                               /*BUG6546*/
                   CHGVAR     VAR(&MESSAGE) VALUE('Unable to allocate data +
                          queue ' *CAT &DTAQ *BCAT 'in ' *cat &LIB)                      /*BUG6546*/
                   SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2472)                        /*BUG6546*/
                   GOTO       CMDLBL(ABNOR)                                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                STRJRNOBJ  OBJ(&LIB/&DTAQ) OBJTYPE(*DTAQ) JRN(ICJRN) +
                             IMAGES(*AFTER)
                MONMSG     MSGID(CPF700A)
                CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)
                CHGVAR     VAR(&MESSAGE) VALUE('Data queue ' *CAT &DTAQ *BCAT +
                             'journalled in library ' *CAT &LIB)
                SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2472)
                DLCOBJ     OBJ((&DTAQ *DTAQ *EXCL))                                      /*BUG6546*/
                MONMSG     MSGID(CPF0000)                                                /*BUG6546*/
                GOTO       CMDLBL(END)
/**********  ENDDO                                                                       /*BUG6546*/
 
/**********  IF         COND((&NJFILE *EQ &DTAQ) *AND (&NJACTV *EQ +                     /*BUG6546*/
/**********               'Y')) THEN(DO)                                                 /*BUG6546*/
/**********     GOTO       CMDLBL(END)                                                   /*BUG6546*/
/**********  ENDDO                                                                       /*BUG6546*/
 
/*/COPY WNCPYSRC,SCC2472MPE                                                                       */
 
/**********  GOTO       CMDLBL(RCVF)                                                     /*BUG6546*/
 
 ABNOR:
/*/COPY WNCPYSRC,SCC2472ERR                                                                       */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC2472 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)
             CHGVAR     VAR(&MESSAGE) VALUE('Program SCC2472 ended +
                          abnormally - see job log')
             SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2472)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCC2472END                                                                       */
 
             RETURN
 
             ENDPGM
