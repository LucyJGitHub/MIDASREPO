     /*****************************************************************/
     /*  Start of /COPY DLC0608003                                    */
     /*****************************************************************/
     /*                                                               */
     /*  Midas - /COPY Member (CLP)                                   */
     /*                                                               */
     /*  DLC0608 - Call AOSARDR0                                      */
     /*                                                               */
     /*  (c) Finastra International Limited 2020                      */
     /*                                                               */
     /*  Last Amend No. EMP104   *Create   Date 22Apr20               */
     /*                                                               */
     /*---------------------------------------------------------------*/
     /*                                                               */
     /*  EMP104 - Remove FX/IRS Exposures and Limits                  */
     /*                                                               */
     /*****************************************************************/
             CHGVAR     VAR(&SSARD) VALUE('EMP104') /*EMP104*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD '*VERIFY' &SSARD) /*EMP104*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR VAR(&EMP104) +
                          VALUE('Y')) /*EMP104*/
             IF         COND(&EMP104 *EQ 'Y') THEN(DO) /*EMP104*/
                CALL       PGM(DL0760) PARM(&RSEQ) /*EMP104*/
             ENDDO      /*EMP104*/
             ELSE       CMD(DO) /*EMP104*/
     /*****************************************************************/
     /*  End of /COPY DLC0608003                                      */
     /*****************************************************************/
