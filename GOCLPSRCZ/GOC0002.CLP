/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Universal transactions update mgr message')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0002 - Universal Transactions Update Manager MESSAGE     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
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
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
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
                GOTO       CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((GPUTJSPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
