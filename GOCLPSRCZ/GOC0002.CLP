/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Universal transactions update mgr message')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0002 - Universal Transactions Update Manager MESSAGE     */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD042877           Date 11Mar24              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD042877 - SCKOBJLCB 00001 failed due to GPUTU* job not     */
/*                  ended.                                           */
/*                - Applied for MD-62365.                            */
/*       MD046248 - Finastra Rebranding                              */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&INST &ZONE &NJOBS)

             DCL        VAR(&INST) TYPE(*CHAR) LEN(5)
             DCL        VAR(&ZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NJOBS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(20)

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZODNWD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZOBCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&RETRY) TYPE(*DEC) LEN(3 0)                                 /*MD042877*/
             DCL        VAR(&MAXRETDTQ) TYPE(*DEC) LEN(3 0) VALUE(200)                  /*MD042877*/
             DCL        VAR(&PLOOP) TYPE(*CHAR) LEN(1)                                  /*MD042877*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                  /*MD042877*/
             DCL        VAR(&GLBSBS) TYPE(*CHAR) LEN(10)                                /*MD042877*/
             DCL        VAR(&GPGJLIB) TYPE(*CHAR) LEN(10)                               /*MD042877*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')

/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Instruction must be END, START, OPENZ OR CLOZ */
/**********  IF         COND(&INST *= 'END' *AND &INST *= 'START' +                   */ /*BG18886*/
/**********               *AND &INST *= 'OPENZ' *AND &INST *= +                       */ /*BG18886*/
/**********               'CLOSZ') THEN(DO)                                           */ /*BG18886*/
             IF         COND(&INST *NE 'END' *AND &INST *NE 'START' +
                          *AND &INST *NE 'OPENZ' *AND &INST *NE +
                          'CLOSZ') THEN(DO)                                              /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO

/* If instruction is START, zone must be defined */
             IF         COND(&INST = 'START' & &ZONE = '          ') +
                          THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

/* If instruction is START or END with zone */
/* if numbers of jobs is defined, it must be 1-9 */
/**********  IF         COND((&INST = 'START') *OR (&INST = 'END  ' +                 */ /*BG18886*/
/**********               *AND &ZONE *= '          ')) THEN(DO)                       */ /*BG18886*/
/**********     IF         COND((&NJOBS *= ' ' & &NJOBS < '1') *OR +                  */ /*BG18886*/
/**********                  (&NJOBS *= ' ' & &NJOBS > '9')) THEN(DO)                 */ /*BG18886*/
             IF         COND((&INST = 'START') *OR (&INST = 'END  ' +
                          *AND &ZONE *NE '          ')) THEN(DO)                         /*BG18886*/
                IF         COND((&NJOBS *NE ' ' & &NJOBS < '1') *OR +
                             (&NJOBS *NE ' ' & &NJOBS > '9')) THEN(DO)                   /*BG18886*/
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO

/* Construct message */
/**********  IF         COND(&ZONE *= '*LIBL') THEN(DO)                               */ /*BG18886*/
             IF         COND(&ZONE *NE '*LIBL') THEN(DO)
                CHGVAR     VAR(&MSG) VALUE(&INST *CAT '|' *CAT &ZONE +
                             *CAT '|' *CAT &NJOBS *CAT '|')
             ENDDO

             IF         COND(&ZONE = '*LIBL') THEN(DO)
                CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                             &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                             &ZONJOB)
/**********     IF         COND(&RTCD *= '       ') THEN(DO)                          */ /*BG18886*/
                IF         COND(&RTCD *NE '       ') THEN(DO)                            /*BG18886*/
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                CHGVAR     VAR(&MSG) VALUE(&INST *CAT '|' *CAT &ZOZONE +
                             *CAT '|' *CAT &NJOBS *CAT '|')
             ENDDO

/* Send message */
             ALCOBJ     OBJ((GPUTJSPD *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                CALL       PGM(GPCSNDJRNE) PARM('UT' &MSG)
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
/**********     GOTO       CMDLBL(END)                 */                               /*MD042877*/
             ENDDO

             DLCOBJ     OBJ((GPUTJSPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
                                                                                        /*MD042877*/
             IF         COND(&INST *EQ 'END') THEN(DO)                                  /*MD042877*/
                                                                                        /*MD042877*/
                CHGVAR     VAR(&RETRY) VALUE(0)                                         /*MD042877*/
LOOP:                                                                                   /*MD042877*/
                RTVOBJD    OBJ(GPJRN) OBJTYPE(*JRN) RTNLIB(&GPGJLIB)                    /*MD042877*/
                CHGVAR     VAR(&SYSID) VALUE(%SST(&GPGJLIB 1 2))                        /*MD042877*/
                CHGVAR     VAR(&GLBSBS) VALUE('M' *CAT &SYSID *CAT 'GSBS')              /*MD042877*/
                WRKACTJOB  SBS(&GLBSBS) OUTPUT(*PRINT)                                  /*MD042877*/
                DLTF       FILE(QTEMP/DSPSBJ)                                           /*MD042877*/
                MONMSG     MSGID(CPF0000)                                               /*MD042877*/
                CRTPF      FILE(QTEMP/DSPSBJ) RCDLEN(132)                               /*MD042877*/
                CPYSPLF    FILE(QPDSPAJB) TOFILE(QTEMP/DSPSBJ) +
                          SPLNBR(*LAST)                                                 /*MD042877*/
                OVRDBF     FILE(DSPSBJ) TOFILE(QTEMP/DSPSBJ)                            /*MD042877*/

                CHGVAR      VAR(&PLOOP) VALUE('N')                                      /*MD042877*/
                CALL       PGM(SCC000302) PARM(&PLOOP)                                  /*MD042877*/
                DLTF       FILE(QTEMP/DSPSBJ)                                           /*MD042877*/
                IF         COND(&PLOOP  *EQ 'Y') THEN(DO)                               /*MD042877*/
                   CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)                             /*MD042877*/
                   IF         COND(&RETRY *LE &MAXRETDTQ) THEN(DO)                      /*MD042877*/
                      DLYJOB     DLY(5)                                                 /*MD042877*/
                      GOTO       CMDLBL(LOOP)                                           /*MD042877*/
                   ENDDO                                                                /*MD042877*/
                   GOTO       CMDLBL(ABNOR)                                             /*MD042877*/
                ENDDO                                                                   /*MD042877*/
                GOTO       CMDLBL(END)                                                  /*MD042877*/
             ENDDO                                                                      /*MD042877*/

             GOTO       CMDLBL(END)

 ABNOR:

/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)

 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
