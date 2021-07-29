     /*****************************************************************/
     /*  Start of /COPY EMP103_002                                    */
     /*****************************************************************/
     /*                                                               */
     /*  Midas - /COPY Member (CLP)                                   */
     /*                                                               */
     /*  HFC0240 - Call AOSARDR0                                      */
     /*                                                               */
     /*  (c) Finastra International Limited 2020                      */
     /*                                                               */
     /*  Last Amend No. EMP103   *Create   Date 16Apr20               */
     /*                                                               */
     /*---------------------------------------------------------------*/
     /*                                                               */
     /*  EMP103 - HAF Suppress Unwanted Entries                       */
     /*                                                               */
     /*****************************************************************/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY') /*EMP103*/
             CHGVAR     VAR(&SARD) VALUE('EMP103') /*EMP103*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &AOFMT) /*EMP103*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR VAR(&EMP103) +
                          VALUE('Y')) /*EMP103*/
     /*****************************************************************/
     /*  End of /COPY EMP103_002                                      */
     /*****************************************************************/
