/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CHGOWNAUT validity checker')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0360VC - Change Ownership & Authority Validity Checker   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      250022             Date 07Aug07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK019             Date 24Jun04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUT001  *CREATE    Date 23JUL98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       250022 - Enhancements to the CHGOWNAUT utility.  Improve    */
/*                checking and move some to actual command.          */
/*       CPK019 - Change error handling.                             */
/*       CUT001 - Bring CHGOWNAUT command and associated programs    */
/*                into core midas                                    */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&OBJLIB &TYPE &NEWOWN &CUROWNAUT &ALLUSER &PUBLIC &AUTL + */ /*CSC043*/
/**********               &CHGLIB &OVRLIBVLD &LOG)                                     */ /*CSC043*/
             PGM        PARM(&OBJLIB &TYPE &NEWOWN &CUROWNAUT +
                          &ALLUSER &PUBLIC &AUTL &CHGLIB &OVRLIBVLD +
                          &LOG &ASP &ASPDEV)                                              /*CSC043*/
 
             DCL        VAR(&OBJLIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWOWN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CUROWNAUT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&AUTL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHGLIB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PUBLIC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ALLUSER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OVRLIBVLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LOG) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(2)                                      /*CSC043*/
             DCL        VAR(&ASPDEV) TYPE(*CHAR) LEN(10)                                  /*CSC043*/
 
             DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AST) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
/**********  DCL        VAR(&AUTLERR) TYPE(*CHAR) LEN(1) VALUE('N')                    */ /*250022*/
             DCL        VAR(&CRTUSER) TYPE(*CHAR) LEN(10)                                 /*250022*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             CHGVAR     VAR(&OBJ) VALUE(%SST(&OBJLIB 1 10))
             CHGVAR     VAR(&OBJL) VALUE(%SST(&OBJLIB 11 10))
 
/* For the library, check whether it exists and that the user is    */
/*  authorised to it.  The existance check may be bypassed,         */
/*  depending upon an Override flag.  This is to allow for the case */
/*  libraries are being created/renamed in batch and the CHGOWNAUT  */
/*  command is being placed in batch behind that job.               */
/*  CPF9801 message is for non-existance, CPF9802 is for lack of    */
/*  authority.                                                      */
 
             IF         COND(&OVRLIBVLD *EQ '*NO') THEN(DO)
                CHKOBJ     OBJ(QSYS/&OBJL) OBJTYPE(*LIB)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                              MSGDTA('0000Library does not exist') +
                              MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)                                               /*CPK019*/
                ENDDO
 
/**********     IF         COND(&ERROR *EQ 'N') THEN(DO)                               */ /*CPK019*/
                CHKOBJ     OBJ(QSYS/&OBJL) OBJTYPE(*LIB) AUT(*ALL)
                MONMSG     MSGID(CPF9800) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000You +
                                lack sufficient authority to the +
                                library') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)                                               /*CPK019*/
                ENDDO
/**********  ENDDO                                                                     */ /*CPK019*/
             ENDDO
 
/* If an object explictily named (i.e. not *ALL or GENERIC) check its existence */
             CALL       PGM(UTC0363) PARM(&OBJ &AST)
             IF         COND(&AST *EQ 'N') THEN(DO)
                IF         COND(&TYPE *EQ '*ALL') THEN(DO)                                /*250022*/
                   DSPOBJD    OBJ(&OBJL/&OBJ) OBJTYPE(&TYPE) OUTPUT(*PRINT)               /*250022*/
                   MONMSG     MSGID(CPF2123) EXEC(DO)                                     /*250022*/
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000No +
                                   objects of this name were found in the +
                                   library' *BCAT &OBJL *TCAT '.') +
                                   MSGTYPE(*DIAG)                                         /*250022*/
                      CHGVAR     VAR(&ERROR) VALUE('Y')                                   /*250022*/
                      GOTO       CMDLBL(ABNOR)                                            /*250022*/
                   ENDDO                                                                  /*250022*/
                ENDDO                                                                     /*250022*/
                ELSE       CMD(DO)                                                        /*250022*/
                   CHKOBJ     OBJ(&OBJL/&OBJ) OBJTYPE(&TYPE)
                   MONMSG     MSGID(CPF9801) EXEC(DO)
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                 MSGDTA('0000Object ' *CAT &OBJ *TCAT ' +
                                 not found in Library ' *CAT &OBJL) +
                                 MSGTYPE(*DIAG)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                      GOTO       CMDLBL(ABNOR)                                            /*CPK019*/
                   ENDDO
                ENDDO                                                                     /*250022*/
             ENDDO
 
/* For the Authorisation List, check that processing can take place.*/
/* CPF98* messages are for non-existance or lack of authority.      */
             IF         COND(&AUTL *NE '*SAME' *AND &AUTL *NE +
                          '*REVOKE') THEN(DO)
                CHKOBJ     OBJ(&AUTL) OBJTYPE(*AUTL) AUT(*CHANGE)
                MONMSG     MSGID(CPF9800) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                           MSGDTA('0000Authorisation list does not +
                           exist') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
/**********     CHGVAR     VAR(&AUTLERR) VALUE('Y')                                    */ /*CPK019*/
                GOTO       CMDLBL(ABNOR)                                                  /*CPK019*/
                ENDDO
             ENDDO
 
/* Check that the user has authority to the new owning profile      */
             IF         COND(&NEWOWN *NE ' ') THEN(DO)
 
                CHKOBJ     OBJ(&NEWOWN) OBJTYPE(*USRPRF) AUT(*CHANGE)
                MONMSG     MSGID(CPF9800) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000New +
                           owning user profile does not exist or you +
                           lack sufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)                                                  /*CPK019*/
                ENDDO
 
             ENDDO
 
/* Check that if an object in QSYS has been requested that it is, for example, */         /*250022*/
/*  a specific library.                                                        */         /*250022*/
             IF         COND(&OBJL *EQ 'QSYS' *AND &TYPE *EQ '*ALL' +
                          *OR &OBJL *EQ 'QSYS' *AND &OBJ *EQ +
                          '*ALL') THEN(DO)                                                /*250022*/
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Cannot change the authority +
                             of mutiple objects in library QSYS') +
                             MSGTYPE(*DIAG)                                               /*250022*/
                CHGVAR     VAR(&ERROR) VALUE('Y')                                         /*250022*/
                GOTO       CMDLBL(ABNOR)                                                  /*250022*/
             ENDDO                                                                        /*250022*/
 
/**Prohibit*revoke*of*current*owners*authority*if*a*new*owner*has****/ /*              */ /*250022*/
/**not*been*specified************************************************/ /*              */ /*250022*/
/**********  IF         COND(&CUROWNAUT *EQ '*REVOKE' *AND &NEWOWN +                   */ /*250022*/
/**********               *EQ ' ') THEN(DO)                                            */ /*250022*/
/**********     SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +                              */ /*250022*/
/**********                MSGDTA('0000Cannot revoke current owners +                  */ /*250022*/
/**********                authority if a new owner has not been +                     */ /*250022*/
/**********                specified') MSGTYPE(*DIAG)                                  */ /*250022*/
/**********     CHGVAR     VAR(&ERROR) VALUE('Y')                                      */ /*250022*/
/**********     GOTO       CMDLBL(ABNOR)                                    */ /*CPK019*/ /*250022*/
/**********  ENDDO                                                                     */ /*250022*/
 
/**Prohibit*Change*Library*=*Y*if*it*is*an*IBM*library***************/ /*              */ /*250022*/
/**********  IF         COND(&CHGLIB *EQ 'Y' *AND %SST(&OBJL 1 1) +                    */ /*250022*/
/**********               *EQ 'Q') THEN(DO)                                            */ /*250022*/
/* Restrict changes to other IBM libraries. */                                            /*250022*/
             IF         COND(&OBJL *NE 'QSYS') THEN(DO)
                RTVOBJD    OBJ(&OBJL) OBJTYPE(*LIB) CRTUSER(&CRTUSER)                     /*250022*/
                IF         COND(&CRTUSER *EQ '*IBM' *OR &CRTUSER *EQ +
                             'QLPINSTALL' *OR &CRTUSER *EQ 'QSECOFR' +
                             *OR &CRTUSER *EQ 'QSECOFR' *OR &CRTUSER +
                             *EQ 'QMQM' *OR &CRTUSER *EQ 'QPM400') +
                             THEN(DO)                                                     /*250022*/
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                              MSGDTA('0000Cannot change the authority +
                              of system libraries via this function') +
                              MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)                                               /*CPK019*/
                ENDDO
             ENDDO                                                                        /*250022*/
 
/**Prohibit*revoke*of*all*users*authority*and*keeping*current********/ /*              */ /*250022*/
/****owners*authority************************************************/ /*              */ /*250022*/
/**********  IF         COND(&CUROWNAUT *EQ '*SAME' *AND &ALLUSER +                    */ /*250022*/
/**********               *EQ 'Y') THEN(DO)                                            */ /*250022*/
 
/* Can only revoke all users' authority if either the new owner is blank */               /*250022*/
/*  or current owner's authority is *REVOKE.                             */               /*250022*/
             IF         COND(&ALLUSER *EQ 'Y') THEN(DO)                                   /*250022*/
                IF         COND(&NEWOWN *NE ' ' *AND &CUROWNAUT *EQ +
                             '*SAME') THEN(DO)                                            /*250022*/
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                              MSGDTA('0000Cannot keep current owners +
                              authority if all users authority is to be +
                              removed') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR)  VALUE('Y')
                   GOTO       CMDLBL(ABNOR)                                               /*CPK019*/
                ENDDO                                                                     /*250022*/
             ENDDO
 
/**Only*permit**AUTL*as*the**PUBLIC*value*if*an*authorisation*list***/ /*              */ /*250022*/
/**has*been*specified************************************************/ /*              */ /*250022*/
/**Only*do*this*test*if*there*was*no*error*on*the*authorisation*list*/ /*              */ /*250022*/
/**********  IF         COND(&AUTLERR *EQ 'N') THEN(DO)                                */ /*CPK019*/
/**********  IF         COND(&PUBLIC *EQ '*AUTL') THEN(DO)                             */ /*250022*/
/**********     IF         COND(&AUTL *EQ '*REVOKE') THEN(DO)                          */ /*250022*/
/**********        SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +                           */ /*250022*/
/**********                     MSGDTA('0000Public authority cannot be +               */ /*250022*/
/**********                     ''*AUTL'' if no authoritsation list has +              */ /*250022*/
/**********                     been specified') MSGTYPE(*DIAG)                        */ /*250022*/
/**********        CHGVAR     VAR(&ERROR) VALUE('Y')                                   */ /*250022*/
/**********        GOTO       CMDLBL(ABNOR)                                 */ /*CPK019*/ /*250022*/
/**********     ENDDO                                                                  */ /*250022*/
/**********  ENDDO                                                                     */ /*250022*/
/**********  ENDDO                                                                     */ /*CPK019*/
 
/**Ensure*that*a*value*has*been*entered*for*one*of*the*New*Owner,****/ /*              */ /*250022*/
/**the*Authorisation*List*or*the*Public*Authority********************/ /*              */ /*250022*/
/**********  IF         COND(&NEWOWN *EQ ' ' *AND &AUTL *EQ '*SAME' +                  */ /*250022*/
/**********               *AND &PUBLIC *EQ '*SAME') THEN(DO)                           */ /*250022*/
/**********    SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000A +                 */ /*250022*/
/**********                 change in one of New Owner, Authorisation +                */ /*250022*/
/**********                 List or Public Authority must be +                         */ /*250022*/
/**********                 specified') MSGTYPE(*DIAG)                                 */ /*250022*/
 
CHANGE:                                                                                   /*250022*/
/* Ensure that a change has been requested. */                                            /*250022*/
             IF         COND(&NEWOWN *EQ ' ' *AND &CUROWNAUT *EQ +
                          '*SAME' *AND &ALLUSER *EQ 'N' *AND &PUBLIC +
                          *EQ '*SAME' *AND &AUTL *EQ '*SAME' *AND +
                          &CHGLIB *EQ 'N') THEN(DO)                                       /*250022*/
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000No +
                             change has actually been requested.') +
                             MSGTYPE(*DIAG)                                               /*250022*/
                CHGVAR     VAR(&ERROR)  VALUE('Y')
                GOTO       CMDLBL(ABNOR)                                                  /*CPK019*/
             ENDDO
 
             GOTO       CMDLBL(END)                                                       /*CPK019*/
 
/*  Send message to cause CPF to pass earlier messages back         */
 
 ABNOR:                                                                                   /*CPK019*/
             IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
 
/**********  GOTO       CMDLBL(END)                                                    */ /*CPK019*/
 
/*ABNOR:***                                                                            */ /*CPK019*/
/**********  SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +                 */ /*CPK019*/
/**********               UTC0360VC ended abnormally - see job +                       */ /*CPK019*/
/**********               log') TOMSGQ(MOPERQ)                                         */ /*CPK019*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)                                         */ /*CPK019*/
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
