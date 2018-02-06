/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Send message to COB users')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0526 - COB SEND MESSAGE TO OTHER USERS                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 08Nov96              */
/*                      S01408             Date 07AUG95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0526INT                                       */
/*                - CBC0526MPS                                       */
/*                - CBC0526MPE                                       */
/*                - CBC0526ERR                                       */
/*                - CBC0526END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USER &JOB &NBR &DTAQ &RTRN)
 
/*/COPY WNCPYSRC,CBC0526INT                                          */
 
/* Declare work variables */
 
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SEV) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MESG) TYPE(*CHAR) LEN(40)
             DCL        VAR(&NICTIM) TYPE(*CHAR) LEN(8) VALUE('  :  +
                          :  ')
             DCL        VAR(&PRTY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLY) TYPE(*CHAR) LEN(12)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TRUENBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(180)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global error message trap */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0526MPS                                          */
 
             RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DATFMT)
             RTVJOBA    NBR(&TRUENBR)
 
             CHGVAR     VAR(&JOBNBR) VALUE(%SST(&DTAQ 4 6))
             CHGVAR     VAR(%SST(&PARM 1 256)) VALUE(' ')
             CHGVAR     VAR(%SST(&MESSAGE 1 40)) VALUE(' ')
             CHGVAR     VAR(%SST(&RTRN 1 8)) VALUE(' ')
             CHGVAR     VAR(&QUAL) VALUE('USRTRACE  *LIBL     ')
 
/* Display Screen */
 
             CALL       PGM(CB0526) PARM(&USER &MESSAGE &DLY &SCD +
                          &TYPE &PRTY &DATFMT &JOBNBR &RTRN)
 
             IF         COND((%SST(&RTRN 1 8)) *NE ' ') THEN(GOTO +
                          CMDLBL(ENDP))
             CHGVAR     VAR(&TEXT) VALUE('Message to ' *CAT &USER +
                        *CAT &MESSAGE *CAT ' PRIORITY : ' *CAT &PRTY)
 
             CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                          X'00000180' &TEXT '0')
 
             CALL       PGM(CB0534)
 
/* if not F3 or F12 */
 
             CHGVAR     VAR(%SST(&PARM 1 7)) VALUE('MESSAGE')
             CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEV)
             CHGVAR     VAR(&TIME) VALUE(%SST(&DLY 1 6))
             CHGVAR     VAR(&DATE) VALUE(%SST(&DLY 7 6))
 
/* Type I is INFO , L is LOCK , S is SIGNOFF */
 
             IF         COND(&TYPE *EQ 'I') THEN(DO)
                IF         COND(&PRTY *EQ 'L') THEN(CHGVAR +
                             VAR(%SST(&PARM 38 2)) VALUE(05))
                IF         COND(&PRTY *EQ 'H') THEN(CHGVAR +
                             VAR(%SST(&PARM 38 2)) VALUE(97))
                CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MESSAGE)
             ENDDO
 
/* If message is not to be scheduled */
 
             IF         COND(&SCD *EQ 'N') THEN(DO)
 
/* Lock */
                IF         COND(&TYPE *EQ 'L') THEN(CALL PGM(CBC0520) +
                             PARM(&DTAQ &ERROR))
 
/* Signoff */
 
                IF         COND(&TYPE *EQ 'S') THEN(CALL PGM(CBC0522) +
                             PARM(&USER &JOB &NBR &DTAQ))
 
/* Message */
 
                IF         COND(&TYPE *EQ 'I') THEN(DO)
                   CALL       PGM(CBC0525) PARM(&DTAQ &PARM)
                ENDDO
 
/* End of do command for Schedule = No */
 
             ENDDO
 
             ELSE       CMD(DO)
 
/* Message is to be scheduled */
 
               CHGVAR     VAR(%SST(&NICTIM 1 2)) VALUE(%SST(&TIME 1 2))
               CHGVAR     VAR(%SST(&NICTIM 4 2)) VALUE(%SST(&TIME 3 2))
               CHGVAR     VAR(%SST(&NICTIM 7 2)) VALUE(%SST(&TIME 5 2))
 
/* Retrieve Message text for Signoff and Lock */
 
               IF         COND(&TYPE *EQ 'S') THEN(DO)
 
/* If the request is Signoff first lock the workstation */
 
                  IF         COND(&JOBNBR *NE &TRUENBR) THEN(DO)
                     CALL       PGM(CB0533) PARM(&USER &JOB &NBR)
                     CALL       PGM(CBC0520) PARM(&DTAQ &ERROR)
                  ENDDO
 
                  RTVMSG     MSGID(CBM0132) MSGF(CBUSRMSG) +
                               MSGDTA(&NICTIM) MSG(&MESG) SEV(&SEV)
/**************   SBMJOB     CMD(CALL PGM(CBC0522) PARM(&USER +       /*110242*/
/*************                 &JOB &NBR &DTAQ)) JOBD(MBATCH) +       /*110242*/
/*************                 SCDDATE(&DATE) SCDTIME(&TIME) */       /*110242*/
/************     SBMJOB    CMD(CALL PGM(CBC0522) PARM(&USER &JOB &NBR  +                 /*CPK014*/
/************             &DTAQ)) JOBD(MBATCH) RTGDTA(*JOBD) +                            /*CPK014*/
/************             INLLIBL(*JOBD) SCDDATE(&DATE) +                                 /*CPK014*/
/************             SCDTIME(&TIME)                              /*110242*/          /*CPK014*/
/************     SBMJOB     CMD(CALL PGM(CBC0522) PARM(&USER &JOB &NBR +                 /*CSC023*/
/************             &DTAQ)) JOBD(MBATCH) USER(*JOBD) +                              /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD) +                                  /*CSC023*/
/************             SCDDATE(&DATE) SCDTIME(&TIME)                        /*CPK014*/ /*CSC023*/
                  SBMJOB     CMD(CALL PGM(CBC0522) PARM(&USER &JOB &NBR +
                          &DTAQ)) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) +
                          SCDDATE(&DATE) SCDTIME(&TIME) OUTQ(*JOBD)                       /*CSC023*/
                  CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEV)
                  CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MESG)
                  CALL       PGM(CBC0525) PARM(&DTAQ &PARM)
                ENDDO
 
                IF         COND(&TYPE *EQ 'L') THEN(DO)
                   RTVMSG     MSGID(CBM0130) MSGF(CBUSRMSG) +
                                MSGDTA(&NICTIM) MSG(&MESG) SEV(&SEV)
/****************  SBMJOB     CMD(CALL PGM(CBC0520) PARM(&DTAQ +      /*110242*/
/*************                  &ERROR)) JOBD(MBATCH) SCDDATE(&DATE) +/*110242*/
/*************                  SCDTIME(&TIME) */                     /*110242*/
/************      SBMJOB     CMD(CALL PGM(CBC0520) PARM(&DTAQ &ERROR)) +                 /*CPK014*/
/************                 JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD) +                 /*CPK014*/
/************                 SCDDATE(&DATE) SCDTIME(&TIME)           /*110242*/          /*CPK014*/
/************      SBMJOB     CMD(CALL PGM(CBC0520) PARM(&DTAQ &ERROR)) +                 /*CSC023*/
/************             JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             INLLIBL(*JOBD) SCDDATE(&DATE) SCDTIME(&TIME)         /*CPK014*/ /*CSC023*/
                   SBMJOB     CMD(CALL PGM(CBC0520) PARM(&DTAQ &ERROR)) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) SCDDATE(&DATE) SCDTIME(&TIME) OUTQ(*JOBD)        /*CSC023*/
                   CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEV)
                   CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MESG)
                   CALL       PGM(CBC0525) PARM(&DTAQ &PARM)
                ENDDO
 
                IF         COND(&TYPE *EQ 'I') THEN(DO)
 
/* Schedule message */
 
/***************** SBMJOB     CMD(CALL PGM(CBC0525) PARM(&DTAQ +      /*110242*/
/*************                  &PARM)) JOBD(MBATCH) SCDDATE(&DATE) + /*110242*/
/*************                  SCDTIME(&TIME) */                     /*110242*/
/************      SBMJOB     CMD(CALL PGM(CBC0525) PARM(&DTAQ &PARM)) +                  /*CPK014*/
/************                 JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD) +                 /*CPK014*/
/************                 SCDDATE(&DATE) SCDTIME(&TIME)           /*110242*/          /*CPK014*/
/************      SBMJOB     CMD(CALL PGM(CBC0525) PARM(&DTAQ &PARM)) +                  /*CSC023*/
/************             JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             INLLIBL(*JOBD) SCDDATE(&DATE) SCDTIME(&TIME)         /*CPK014*/ /*CSC023*/
                   SBMJOB     CMD(CALL PGM(CBC0525) PARM(&DTAQ &PARM)) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) SCDDATE(&DATE) SCDTIME(&TIME) OUTQ(*JOBD)        /*CSC023*/
                ENDDO
 
             ENDDO
 
/*/COPY WNCPYSRC,CBC0526MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBC0526ERR                                          */
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,CBC0526END                                          */
 
             ENDPGM
