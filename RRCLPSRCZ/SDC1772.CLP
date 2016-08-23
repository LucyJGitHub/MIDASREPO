/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Rep last successful trans on primary mach')  */
/********************************************************************/
/*                                                                  */
/*       Midas - Restart Recovery Module                            */
/*                                                                  */
/*       SDC1772 - Rebuild all files read from data queue REBUILD   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK016             Date 29Aug03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             DATE  10MAY95            */
/*                      E19691             DATE  12NOV89            */
/*                      E13205             DATE  14FEB89            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CPK016 - Release 5 packaging.  Make data queue REBUILD      */
/*                permanent.                                         */
/*       S01408 - Addition of core hook SDC1772MPS                  */
/*       E19691 - SDC1772 SHOULD BE ALLOCATED (*SHRRD) FOR THE      */
/*                PERIOD THAT THE SDC1772 BATCH JOBS RUN.           */
/*                                                                  */
/*       New program overview                                       */
/*                                                                  */
/*       E13205 - For each Logical file in list open and close      */
/*                file if not already done                          */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(30)
/**********  DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)                                 */ /*CPK016*/
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(30)
/**********  DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)                              */ /*CPK016*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/                                                                  /*E19691*/
/*           Allocate SDC1772 *SHRRD to speed up processing        */ /*E19691*/
/**/                                                                  /*E19691*/
             ALCOBJ     OBJ((SDC1772 *PGM *SHRRD))                    /*E19691*/
             MONMSG     MSGID(CPF1002)                                /*E19691*/
/**/
/**********  RTVDTAARA  DTAARA(*LIBL/SDSTAT (6 2)) RTNVAR(&DBPREFIX)                   */ /*CPK016*/
/**********  CHGVAR     VAR(&JLIB) VALUE(&DBPREFIX *CAT 'JLIB')                        */ /*CPK016*/
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1772MPS                                          */
                                                                      /*S01408*/
/*           Receive from data queue REBUILD                         */
/**/
/*READ:****  CALL       PGM(*LIBL/QRCVDTAQ) PARM('REBUILD' &JLIB +                     */ /*CPK016*/
/**********               &FLDLEN &DATA &WAIT)                                         */ /*CPK016*/
  READ:                                                                                   /*CPK016*/
             CALL       PGM(*LIBL/QRCVDTAQ) PARM('REBUILD' '*LIBL' +
                          &FLDLEN &DATA &WAIT)                                            /*CPK016*/
             IF         COND(&FLDLEN *EQ 0) THEN(GOTO CMDLBL(END))
/**/
/*           Verify if rebuilt                                       */
/**/
             CHGVAR     VAR(&FILE) VALUE(%SST(&DATA 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&DATA 11 10))
             CHGVAR     VAR(&NAME) VALUE(%SST(&DATA 21 10))
             CALL       PGM(*LIBL/SD1731) PARM('*VERIFY' &FILE &LIB +
                          &NAME &RTNCDE)
             IF         COND(&RTNCDE *EQ '*ERROR') THEN(GOTO +
                          CMDLBL(ABNOR))
             IF         COND(&RTNCDE *EQ '*DONE') THEN(GOTO +
                          CMDLBL(READ))
/**/
/*           Rebuild file                                            */
/**/
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE) MBR(&NAME)
             MONMSG     MSGID(CPF9800 CPF0001) EXEC(GOTO CMDLBL(READ))
/**/
/*           Open and close the file                                 */
/**/
             OPNDBF     FILE(&LIB/&FILE) OPTION(*INP) MBR(&NAME)
             MONMSG     MSGID(CPF4125 CPF4128) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Rebuild of file ' *BCAT &FILE *TCAT +
                          '.' *TCAT &LIB *BCAT ' member ' *BCAT &NAME +
                          *BCAT ' failed - rebuild process +
                          continues') TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
/**/
             GOTO       CMDLBL(READ)
/**/
             ENDDO
             CLOF       OPNID(&FILE)
/**/
/*           Set up file as being rebuilt                            */
/**/
             CALL       PGM(*LIBL/SD1731) PARM('*REBUILT' &FILE &LIB +
                          &NAME &RTNCDE)
             IF         COND(&RTNCDE *EQ '*ERROR') THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
             GOTO       CMDLBL(READ)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1772 - Rebuild all files read +
                          from data queue REBUILD - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/****END:         ENDPGM  */                                          /*E19691*/
END:         DLCOBJ     OBJ((SDC1772 *PGM *SHRRD))                    /*E19691*/
             MONMSG     MSGID(CPF1005)                                /*E19691*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*E19691*/
