/*****************************************************************/
/*  Start of /COPY EMP104_039                                    */
/*****************************************************************/
/*                                                               */
/*  Midas - /COPY Member (CLP)                                   */
/*                                                               */
/*  DLC0608B - Call AOSARDR0                                     */
/*                                                               */
/*  (c) Finastra International Limited 2020                      */
/*                                                               */
/*  Last Amend No. EMP104   *Create   Date 28Apr20               */
/*                                                               */
/*---------------------------------------------------------------*/
/*                                                               */
/*  EMP104 - Remove FX/IRS Exposures and Limits                  */
/*                                                               */
/*****************************************************************/
             CALL       PGM(AOSARDR0) PARM(&PRTCD '*VERIFY' 'EMP104') /*EMP104*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR VAR(&EMP104) +
                          VALUE('Y')) /*EMP104*/
             IF         COND(&EMP104 *EQ 'Y') THEN(DO) /*EMP104*/
                CALL       PGM(DL0760) PARM(&RSEQ) /*EMP104*/
             ENDDO      /*EMP104*/
             ELSE       CMD(DO) /*EMP104*/
/*****************************************************************/
/*  End of /COPY EMP104_039                                      */
/*****************************************************************/
