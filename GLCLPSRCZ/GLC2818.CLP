/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis background process')                  */
/*********************************************************************/
/*                                                                   */
/*   Midas - Midas-Fontis Interface                                  */
/*                                                                   */
/*   GLC2818    Fontis Background Process                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 06Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      180223             Date 13Jun00              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*   Prev Amend No. 169526               Date 20Oct99                */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  CGL004 *CREATE       Date 18FEB97                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   CPK014 - Release 4 packaging.                                   */
/*            - DTAQ/GLFONTA should be cleared rather than deleted   */
/*              for authority reasons.                               */
/*   180223 - General initialisation problems.                       */
/*   169526 - Provide recovery for GLFONAPD & GLRSSVPD.              */
/*            Here, include STRCMTCTL to support KCOMIT in GL2805.   */
/*   CGL004 - Midas-Fontis Interface                                 */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ANUM)   TYPE(*CHAR) LEN(18)
/************DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)                                  */ /*180223*/
/************DCL        VAR(&LIBNAM) TYPE(*CHAR) LEN(10)                               */ /*180223*/
/************DCL        VAR(&MNM) TYPE(*CHAR) LEN(10)                                  */ /*180223*/
/************DCL        VAR(&MSGTYP) TYPE(*CHAR) LEN(3)                                */ /*180223*/
/************DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                  */ /*180223*/
/************DCL        VAR(&RETRY) TYPE(*DEC) LEN(1 0)                                */ /*180223*/
/************DCL        VAR(&HOST) TYPE(*CHAR) LEN(30)                                 */ /*180223*/
             DCL        VAR(&WAITTM) TYPE(*DEC)  LEN(5 0)
/************DCL        VAR(&MSG)    TYPE(*CHAR) LEN(52)                               */ /*180223*/
             DCL        VAR(&DTQVAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                        /*180223*/ /*CPK014*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                        /*180223*/ /*CPK014*/
 
             DCL        VAR(&DAFONT) TYPE(*CHAR) LEN(256) VALUE(' ')
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GLC2818 - Fontis Background processing') +
                          TOMSGQ(MRUNQ)
 
/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
 
/* Create DA/LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
/**Delete*and*re-create*data*queue*GLFONTA**/                                  /*180223*/ /*CPK014*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                   /*180223*/ /*CPK014*/
/**********  CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *TCAT 'DPLIB')               /*180223*/ /*CPK014*/
/**********  DLTDTAQ    DTAQ(GLFONTA)                                          /*180223*/ /*CPK014*/
/**********  MONMSG     MSGID(CPF0000)                                         /*180223*/ /*CPK014*/
/**********  CRTDTAQ    DTAQ(&DPLIB/GLFONTA) MAXLEN(1) +                       /*180223*/ /*CPK014*/
/**********               TEXT('Midas-Fontis interface, MT940s and +           /*180223*/ /*CPK014*/
/**********               MT942s')                                             /*180223*/ /*CPK014*/
                                                                                          /*CPK014*/
/* Clear data queue GLFONTA */                                                            /*CPK014*/
                                                                                          /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('GLFONTA' '*LIBL ')                            /*CPK014*/
                                                                                          /*180223*/
/**/                                                                  /*169526*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*169526*/
             MONMSG     MSGID(CPF8351)                                /*169526*/
                                                                      /*169526*/
 
/* RETRIEVE JOB ATTRIBUTES */
 
             RTVJOBA    JOB(&JOBN) USER(&USRN) NBR(&JBNB)
 
/* AMEND GLFONTDA WITH JOB DETAILS                                   */
 
             RTVDTAARA  DTAARA(GLFONTDA) RTNVAR(&DAFONT)
             CHGDTAARA  DTAARA(GLFONTDA (1 26)) VALUE(&JOBN *CAT +
                          &USRN *CAT &JBNB)
/**/
 TIMEOUT:    RTVDTAARA  DTAARA(GLFONTDA) RTNVAR(&DAFONT)
             IF         COND(%SST(&DAFONT 27 1) *EQ 'Y') THEN(DO)
               CALL       PGM(GLC2805) PARM(&ANUM)
/**/
/* If U7 or U8 are ON, perform standard database error processing */
 
               IF         COND(%SWITCH(XXXXXX1X) *OR +
                            %SWITCH(XXXXXXX1)) THEN(DO)
                 GOTO       CMDLBL(ABNOR)
               ENDDO
             ENDDO
             IF         COND(%SST(&DAFONT 30 1) *EQ 'Y') THEN(CALL +
                          PGM(GLC2806) PARM(&WAITTM))
/**/
/* If U7 or U8 are ON, perform standard database error processing */
 
               IF         COND(%SWITCH(XXXXXX1X) *OR +
                            %SWITCH(XXXXXXX1)) +
                 THEN(GOTO       CMDLBL(ABNOR))
               CALL       PGM(QRCVDTAQ) PARM(GLFONTA *LIBL +
                            X'00001F' &DTQVAL &WAITTM)
 
/* If returned value is T, program is immediately terminated  */
 
               IF         COND((&DTQVAL *EQ ' ') *OR (&DTQVAL *EQ +
                            'C')) THEN(GOTO CMDLBL(TIMEOUT))
 
             CHGDTAARA  DTAARA(GLFONTDA (1 26)) +
                          VALUE('                          ')
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
/**/
 ABNOR:        CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA+
                          ('Program GLC2818 ended abnormally - +
                          see job log') TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
/**ENDPGM:*****ENDPGM  */                                             /*169526*/
 ENDPGM:                                                              /*169526*/
             ENDCMTCTL                                                /*169526*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM                                                   /*169526*/
