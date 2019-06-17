/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('G-AML Extraction Processing')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/********SCCJ004*-*G-AML Extraction Processing************************/
/*       XXC109005 - G-AML Extraction Processing                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. JMI109             Date 22May18              */
/*       Prev Amend No. JMI026   *CREATE   Date 11Sep08              */
/*********************************************************************/
/*                                                                   */
/*       JMI109 - G-AML PreProcessor (Upgrade to FB Midas)           */
/*       JMI026 - G-AML PreProcessor                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &RERUN &SEQ &LEV &ENT &DATA)

/* Copyright Statement                                               */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')

/* Declare Variables                                                 */

             DCL        VAR(&CNAM) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&JOBNAME) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RETRN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SEQ) TYPE(*CHAR)  LEN(5)
             DCL        VAR(&DTA) TYPE(*CHAR) LEN(7) VALUE(*BLANKS)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(100)

/* Global Message Monitor                                            */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Create Data Area in QTEMP                                         */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)

/* Allocate Data Area GAMLDTA                                        */

             ALCOBJ     OBJ((GAMLDTA *DTAARA *EXCL))
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ABNOR))

/* Set off all user job switches                                     */

             CHGJOB     SWS(00000000)

/* Retrieve Job Attributes                                           */

             RTVJOBA    JOB(&JOBNAME) USER(&JOBUSER) NBR(&JOBNO)

/* Assign &RERUN to the first position of &DATA                      */
             CHGVAR     VAR(%SST(&DATA 1 1)) VALUE(&RERUN)

/* Amend GAMLDTA with Job Details                                    */

             CHGDTAARA  DTAARA(GAMLDTA (1 26)) VALUE(&JOBNAME *CAT +
                          &JOBUSER *CAT &JOBNO)

/* Clear files                                                       */

/**********  CLRPFM     FILE(SDCSTFPP)                               */                   /*JMI109*/
/**********  CLRPFM     FILE(RECIFFPP)                               */                   /*JMI109*/
/**********  CLRPFM     FILE(REACFFPP)                               */                   /*JMI109*/
/**********  CLRPFM     FILE(REACEFPP)                               */                   /*JMI109*/
             CLRPFM     FILE(XXCSTFPD)                                                    /*JMI109*/
             CLRPFM     FILE(XXCIFFPD)                                                    /*JMI109*/
             CLRPFM     FILE(XXACFFPD)                                                    /*JMI109*/
             CLRPFM     FILE(XXACEFPD)                                                    /*JMI109*/

/* Call SCJ00005 to extract Customer Details                         */

/**********  CALL       PGM(SCJ00005) PARM(&RETRN &SEQ)              */                   /*JMI109*/
             CALL       PGM(XX109006) PARM(&RETRN &SEQ)                                   /*JMI109*/

             IF         COND(&RETRN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Call SCJ00006 to extract Account Details                          */

/**********  CALL       PGM(SCJ00006) PARM(&RETRN &SEQ)              */                   /*JMI109*/
             CALL       PGM(XX109007) PARM(&RETRN &SEQ)                                   /*JMI109*/

             IF         COND(&RETRN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Call SCJ00007 to extract Activity Details                         */

/**********  CALL       PGM(SCJ00007) PARM(&RETRN &CSEQ &DATA)       */                   /*JMI109*/
             CALL       PGM(XX109008) PARM(&RETRN &CSEQ &DATA)                            /*JMI109*/

             IF         COND(&RETRN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Call SCJ00008 to print all the extracted Activity Details         */

/**********  CALL       PGM(SCJ00008) PARM(&RETRN &SEQ &DATA)        */                   /*JMI109*/
             CALL       PGM(XX109009) PARM(&RETRN &SEQ &DATA)                             /*JMI109*/

             IF         COND(&RETRN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Call SCCJ003 for FTP processing                                   */

/**********  CALL       PGM(SCCJ003) PARM(&RETRN &DATA)              */                   /*JMI109*/
             CALL       PGM(XXC109010) PARM(&RETRN &DATA)                                 /*JMI109*/

             IF         COND(&RETRN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

             GOTO       CMDLBL(END)

/* Abnormal Processing                                               */

 ABNOR:      CHGJOB     SWS(XXXXXX11)

                        DMPCLPGM

             SNDPGMMSG  MSG('G-AML Extraction Processing +
                             Ended Abnormally') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

/* Program End                                                       */

 END:        DLCOBJ     OBJ((GAMLDTA *DTAARA *EXCL))
             ENDPGM
