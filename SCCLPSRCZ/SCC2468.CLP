/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Journal unjournalled data areas')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2468 - Journal Unjournalled Data Areas                   */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. AR1019279          Date 21Sep12              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG6546            Date 25Apr05              */
/*       Prev Amend No. CSC020             Date 31Mar04              */
/*                      CSC018 *CREATE     Date 31May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1019279 - Reinstate programs SCC2462 and SCC2468 in BF.   */
/*       BUG6546 - Check SCNJRNL1 in calling program SCC2466 and     */
/*                 SCC2467. Remove RCVF loop from this program.      */
/*               - Locking problem. Allocate object before trying    */
/*                 to start journalling                              */
/*       CSC020 - Journaling changes for MidasPlus                   */
/*       CSC018 - Journaling options for high availability           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DTAA &LIB)
 
/*/COPY WNCPYSRC,SCC2468INT                                                                       */
 
             DCL        VAR(&DTAA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSGCLR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
/**********  DCLF       FILE(SCNJRNL1) */                                                /*BUG6546*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC2468MPS                                                                       */
 
             CRTMSGQ    MSGQ(QTEMP/SCC2468)
             MONMSG     MSGID(CPF0000)
/*                                                                                          CSC020*/
/* If the data area name starts 'MSMR' then do not process further.                         CSC020*/
/*                                                                                          CSC020*/
             IF         COND(%SST(&DTAA 1 4) *EQ 'MSMR') THEN(GOTO +
                          CMDLBL(END))                                                    /*CSC020*/
 
/**Check*to*see*if*the*date*area*should*be*journalled*and*if*so,                         /*BUG6546*/
/**journal*it.                                                                           /*BUG6546*/
 
/*RCVF:****                                                                              /*BUG6546*/
/**********  RCVF                                                                        /*BUG6546*/
/**********  MONMSG     MSGID(CPF0864) EXEC(DO)                                          /*BUG6546*/
                ALCOBJ     OBJ((&DTAA *DTAARA *EXCL)) WAIT(0)                            /*BUG6546*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                                       /*BUG6546*/
                   CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)                               /*BUG6546*/
                   CHGVAR     VAR(&MESSAGE) VALUE('Unable to allocate data +
                          area ' *CAT &DTAA *BCAT 'in ' *cat &LIB)                       /*BUG6546*/
                   SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2468)                        /*BUG6546*/
                   GOTO       CMDLBL(ABNOR)                                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                STRJRNOBJ  OBJ(&LIB/&DTAA) OBJTYPE(*DTAARA) JRN(ICJRN) +
                             IMAGES(*BOTH)
                MONMSG     MSGID(CPF700A)
                CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)
                CHGVAR     VAR(&MESSAGE) VALUE('Data area ' *CAT &DTAA *BCAT +
                             'journalled in library ' *CAT &LIB)
                SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2468)
                DLCOBJ     OBJ((&DTAA *DTAARA *EXCL))                                    /*BUG6546*/
                MONMSG     MSGID(CPF0000)                                                /*BUG6546*/
                GOTO       CMDLBL(END)
/**********  ENDDO                                                                       /*BUG6546*/
 
/**********  IF         COND((&NJFILE *EQ &DTAA) *AND (&NJACTV *EQ +                     /*BUG6546*/
/**********               'Y')) THEN(DO)                                                 /*BUG6546*/
/**********     GOTO       CMDLBL(END)                                                   /*BUG6546*/
/**********  ENDDO                                                                       /*BUG6546*/
 
/*/COPY WNCPYSRC,SCC2468MPE                                                                       */
 
/**********  GOTO       CMDLBL(RCVF)                                                     /*BUG6546*/
 
 ABNOR:
/*/COPY WNCPYSRC,SCC2468ERR                                                                       */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC2468 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&MESSAGE) VALUE(&MSGCLR)
             CHGVAR     VAR(&MESSAGE) VALUE('Program SCC2468 ended +
                          abnormally - see job log')
             SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2468)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited') 
 
/*/COPY WNCPYSRC,SCC2468END                                                                       */
 
             RETURN
 
             ENDPGM
