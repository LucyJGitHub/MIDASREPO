/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Set up library list from MIDASIC jobd')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0014 - Apply library list from MIDASIC to current job    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BG6475             Date 11Apr05              */
/*                      CPK016             Date 22Jul03              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 21Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG6475 - Parameter for retrieval of data is too small.      */
/*       CPK016 - Release 5 packaging.  Change program so that it    */
/*                does not need a Midas library list to run.         */
/*       CSC017 - Change to 250 library list.                        */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SBS)
 
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(2)
 
/************DCL        VAR(&CMD) TYPE(*CHAR) LEN(289)                                 */ /*CSC017*/
/************DCL        VAR(&INLLIBL) TYPE(*CHAR) LEN(275)                             */ /*CSC017*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2764)                                   /*CSC017*/
             DCL        VAR(&INLLIBL) TYPE(*CHAR) LEN(2750)                               /*CSC017*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBDNAME) TYPE(*CHAR) LEN(10)                                /*CPK016*/
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(20)                                    /*CPK016*/
             DCL        VAR(&LEN) TYPE(*CHAR) LEN(4)                                      /*CPK016*/
/**********  DCL        VAR(&PARM) TYPE(*CHAR) LEN(1000)                    */ /*CPK016*/ /*BG6475*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(3193)                                  /*BG6475*/
             DCL        VAR(&OFFSET) TYPE(*DEC) LEN(9 0)                                  /*CPK016*/
             DCL        VAR(&LIBCNT) TYPE(*DEC) LEN(9 0)                                  /*CPK016*/
             DCL        VAR(&OFFLEN) TYPE(*DEC) LEN(9 0)                                  /*CPK016*/
             DCL        VAR(&ERRCDE) TYPE(*CHAR) LEN(4)                                   /*CPK016*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(70)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
             CHGVAR     VAR(&LIB) VALUE(&SBS *CAT 'XLIB')
 
             CHKOBJ     OBJ(&LIB/MIDASIC) OBJTYPE(*JOBD)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810 CPF9820 +
                          CPF9830 CPF9899) EXEC(GOTO CMDLBL(ABNOR))
 
/************RTVJOBD    JOBD(&LIB/MIDASIC) INLLIBL(&INLLIBL)                           */ /*CPK016*/
 
/* Set up parameters for call to IBM API. */                                              /*CPK016*/
             CHGVAR     VAR(&JOBDNAME) VALUE('MIDASIC')                                   /*CPK016*/
             CHGVAR     VAR(&JOBD) VALUE(&JOBDNAME *CAT &LIB)                             /*CPK016*/
/**********  CHGVAR     VAR(%BIN(&LEN 1 4)) VALUE(1000)                     */ /*CPK016*/ /*BG6475*/
             CHGVAR     VAR(%BIN(&LEN 1 4)) VALUE(3193)                                   /*BG6475*/
             CHGVAR     VAR(%BIN(&ERRCDE 1 4)) VALUE(0)                                   /*CPK016*/
 
/* Use API to access the job description library list. */                                 /*CPK016*/
             CALL       PGM(QWDRJOBD) PARM(&PARM &LEN JOBD0100 &JOBD +
                          &ERRCDE)                                                        /*CPK016*/
 
 INLLIBL:    CHGVAR     &OFFSET %BIN(&PARM 361 4)                                         /*CPK016*/
             CHGVAR     VAR(&OFFSET) VALUE(&OFFSET + 1)                                   /*CPK016*/
             CHGVAR     VAR(&LIBCNT) VALUE(%BIN(&PARM 365 4))                             /*CPK016*/
             CHGVAR     VAR(&OFFLEN) VALUE(11 * &LIBCNT)                                  /*CPK016*/
             CHGVAR     VAR(&INLLIBL) VALUE(%SST(&PARM &OFFSET +
                          &OFFLEN))                                                       /*CPK016*/
             MONMSG     MSGID(MCH3601)                                                    /*CPK016*/
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                                    */ /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSC017*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             RCVMSG     MSGDTA(&MSGDTA) MSGID(&MSGID)
             IF         COND(&MSGID *NE '       ') THEN(DO)
                SNDPGMMSG MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOPGMQ(*EXT) MSGTYPE(*INFO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
