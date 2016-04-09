/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT EXPSRC validation and call/submit')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       UTC0015 - Expand source: Validation and call/submit         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018  *MOVED     Date 26Apr04              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 28May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAAA01             Date 30Oct95              */
/*                      078080             Date 28Oct94              */
/*                      S01516             Date 18Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes                          */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSC017 - Change to 250 library list.  Take out change of    */
/*                job description.                                   */
/*       CPK015 - 4.01 packaging.  Change submit job USER.           */
/*       CAAA01 - Allow expanded source to be retained for Midas GUI */
/*                Collector to run and make bold printing optional   */
/*                for EXPSRC                                         */
/*       078080 - Ensure correct message sent to user when job       */
/*                submitted.                                         */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&MBR &FILLIB &SUBM &OUTPUT &JOBQ)******/ /*CAAA01*/
             PGM        PARM(&MBR &FILLIB &SUBM &OUTPUT &JOBQ &BOLD)  /*CAAA01*/
 
             DCL        VAR(&FILLIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&MBR) TYPE(*CHAR) LEN(8)         ***/     /*CAAA01*/
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)                 /*CAAA01*/
             DCL        VAR(&SUBM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BOLD) TYPE(*CHAR) LEN(1)                 /*CAAA01*/
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WRKSTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)
             DCL        &MSGID *CHAR LEN(7)
             DCL        &MSGDTA *CHAR LEN(100)
             DCL        &MSGF *CHAR LEN(10)
             DCL        &MSGFLIB *CHAR LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             RTVJOBA    JOB(&WRKSTN) USER(&USER)
             CHGVAR     VAR(&FILE) VALUE(%SST(&FILLIB 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&FILLIB 11 10))
 
/*    Check file exists                                              */
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/************SNDPGMMSG  MSGID(CPF3012) MSGF(QCPFMSG) MSGDTA(&FILE****+  */ /*BG18886*/
/************             &LIB) MSGTYPE(*ESCAPE)                        */ /*BG18886*/
             SNDPGMMSG  MSGID(CPF3012) MSGF(QCPFMSG) MSGDTA(&FILE *CAT +
                          &LIB) MSGTYPE(*ESCAPE)                           /*BG18886*/
             RETURN
             ENDDO
 
/*    Check object authority                                         */
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE) AUT(*USE)
             MONMSG     MSGID(CPF9802) EXEC(DO)
/************SNDPGMMSG  MSGID(CPF9822) MSGF(QCPFMSG) MSGDTA(&FILE****+  */ /*BG18886*/
/************             &LIB) MSGTYPE(*ESCAPE)                        */ /*BG18886*/
             SNDPGMMSG  MSGID(CPF9822) MSGF(QCPFMSG) MSGDTA(&FILE *CAT +
                          &LIB) MSGTYPE(*ESCAPE)                           /*BG18886*/
             RETURN
             ENDDO
 
/*    Check member exists                                            */
             RTVMBRD    FILE(&LIB/&FILE) MBR(&MBR)
             MONMSG     MSGID(CPF0000) EXEC(DO)
/************SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Source +   */ /*BG18886*/
/************             member(s) '****&MBR****' not found in +       */ /*BG18886*/
/************             file '****&FILE) MSGTYPE(*ESCAPE)             */ /*BG18886*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Source +
                          member(s) ' *CAT &MBR *TCAT ' not found in +
                          file ' *CAT &FILE) MSGTYPE(*ESCAPE)
             RETURN
             ENDDO
 
/*  Check for whether or not the user is attempting to run the      */
/*     job interactively whilst Parm '&MBR' eq '*ALL'               */
 
/************IF         COND((&SUBM****'Y') & (&MBR = '*ALL')) THEN(DO) */ /*BG18886*/
             IF         COND((&SUBM *NE 'Y') & (&MBR = '*ALL')) +
                          THEN(DO)                                         /*BG18886*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('If +
                          expanding *ALL source members, job must +
                          be submitted to batch') MSGTYPE(*ESCAPE)
             RETURN
             ENDDO
 
/*    Scan 'Member' for '*' in case of 'Generic' or 'All'            */
             CHGVAR     VAR(&STRLEN) VALUE(10)
             CHGVAR     VAR(&STRPOS) VALUE(1)
             CHGVAR     VAR(&PATLEN) VALUE(1)
             CALL       PGM(QCLSCAN) PARM(&MBR &STRLEN &STRPOS +
                            '*' &PATLEN '0' '0' '' &RESULT)
 
/*    Output * only allowed for single member                        */
             IF         COND((&RESULT > 0) & (&OUTPUT = '*')) THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Output +
                          must be *PRINT if expanding generic or +
                          *ALL members') MSGTYPE(*ESCAPE)
             RETURN
             ENDDO
 
/*    Output * not allowed if submitting job to batch                */
             IF         COND((&SUBM = 'Y') & (&OUTPUT = '*')) THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Output +
                          must be *PRINT if submitting job to +
                          batch') MSGTYPE(*ESCAPE)
             RETURN
             ENDDO
 
/*    Check JOBD UTJOBD exists if batch job                          */
 
             IF         COND(&SUBM = 'Y') THEN(DO)
             CHKOBJ     OBJ(UTJOBD) OBJTYPE(*JOBD)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID)
             SNDPGMMSG  MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
             RETURN             /*  ==>> */
             ENDDO
             ENDDO
 
/*    Submit job to batch if requested                               */
 
             IF         COND(&SUBM *EQ 'Y') THEN(DO)
/************CHGJOBD    JOBD(UTJOBD) USER(&USER)                                       */ /*CSC017*/
/************MONMSG     MSGID(CPF0000)                                /*078080*/
             RCVMSG     MSGTYPE(*COMP)                                /*078080*/
/************SBMJOB     CMD(CALL PGM(UTC0016) PARM(&FILE &LIB &MBR +  /*CAAA01*/
/************             &SUBM &WRKSTN &OUTPUT)) JOB(EXPAND) +       /*CAAA01*/
/************             JOBD(UTJOBD) JOBQ(&JOBQ) **/                /*CAAA01*/
/************SBMJOB     CMD(CALL PGM(UTC0016) PARM(&FILE &LIB &MBR +                   */ /*CPK015*/
/************             &SUBM &WRKSTN &OUTPUT &BOLD)) JOB(EXPAND) +                  */ /*CPK015*/
/************             JOBD(UTJOBD) JOBQ(&JOBQ)                             /*CAAA01*/ /*CPK015*/
             SBMJOB     CMD(CALL PGM(UTC0016) PARM(&FILE &LIB &MBR +
                          &SUBM &WRKSTN &OUTPUT &BOLD)) JOB(EXPAND) +
                          JOBD(UTJOBD) JOBQ(&JOBQ) USER(*JOBD)                            /*CPK015*/
             RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*COMP)
             ENDDO
 
/*    Otherwise run expand at workstation                            */
 
             IF         COND(&SUBM *NE 'Y') THEN(DO)
/**********  CALL       PGM(UTC0016) PARM(&FILE &LIB &MBR &SUBM +     /*CAAA01*/
/**********               &WRKSTN &OUTPUT) **/                        /*CAAA01*/
             CALL       PGM(UTC0016) PARM(&FILE &LIB &MBR &SUBM +
                          &WRKSTN &OUTPUT &BOLD)                      /*CAAA01*/
             RCVMSG     MSGTYPE(*COMP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
/**********  IF         COND(&MSGID****'       ') THEN(DO)           */ /*BG18886*/
             IF         COND(&MSGID *NE '       ') THEN(DO)             /*BG18886*/
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*COMP)
             ENDDO
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
       ENDPGM
