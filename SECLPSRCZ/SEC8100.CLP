/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8100  - Position Calculation Routine                     */
/*                                                                   */
/*       Called By: XX118004 - Generate Position Settlements - Depots*/
/*                  XX118008 - Generate Position Settlements - Cust  */
/*                                                                  */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. HUT118A *CREATE    Date 03Nov22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT118A - Position Settlements Online Generation (CSE063)   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BRCD &SESN &BKCD &MARK &DEPOT &CUST  +
                        &PTFR &BASIS &DATE &TYPE &REPO &UAUT +
                        &BALA &XBAL &PRIC &ERR)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) finastra Ltd. +
                          2022')
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SESN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BKCD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MARK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEPOT) TYPE(*CHAR) LEN(6)               /*HUT118A*/
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(6)                /*HUT118A*/
             DCL        VAR(&PTFR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BASIS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATE) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&UAUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BALA) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&XBAL) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&PRIC) TYPE(*DEC) LEN(15 8)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)

/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNORM))

/*  Set job switches  */
             CHGJOB SWS(XXXXXX00)


/*  Call SEC8110 to calculate Customer Depot Position  */
             IF         COND(&TYPE *EQ 'E') THEN(DO)
               CALL       PGM(SEC8110) PARM(&BRCD &SESN &BKCD &MARK +
                          &DEPOT &CUST &PTFR &BASIS &DATE &TYPE +
                          &REPO &UAUT &BALA &XBAL &PRIC &ERR)
             ENDDO

/*  Call SEC8120 to calculate User Depot Position  */
             IF         COND(&TYPE *EQ 'U') THEN(DO)
               CALL       PGM(SEC8120) PARM(&BRCD &SESN &BKCD &MARK +
                          &DEPOT &CUST &PTFR &BASIS &DATE &TYPE +
                          &REPO &UAUT &BALA &XBAL &PRIC &ERR)
             ENDDO

/*  Call SEC8130 to calculate Customer Position  */
             IF         COND(&TYPE *EQ 'C') THEN(DO)
               CALL       PGM(SEC8130) PARM(&BRCD &SESN &BKCD &MARK +
                          &DEPOT &CUST &PTFR &BASIS &DATE &TYPE +
                          &REPO &UAUT &BALA &XBAL &PRIC &ERR)
             ENDDO

/*  Call SEC8140 to calculate Depot Position  */
             IF         COND(&TYPE *EQ 'D') THEN(DO)
               CALL       PGM(SEC8140) PARM(&BRCD &SESN &BKCD &MARK +
                          &DEPOT &CUST &PTFR &BASIS &DATE &TYPE +
                          &REPO &UAUT &BALA &XBAL &PRIC &ERR)
             ENDDO

/*  Return to calling program  */
             RETURN


 ABNORM:
             SNDPGMMSG  MSG('Program SEC8100 ended abnormally - see +
                          job log for detail') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra Ltd.')
             ENDPGM
