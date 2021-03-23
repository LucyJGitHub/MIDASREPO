     /*****************************************************************/
     /*  Start of /COPY EML113_002                                    */
     /*****************************************************************/
     /*                                                               */
     /*  Midas - /COPY Member (CLP)                                   */
     /*                                                               */
     /*  EML113_002 - Call AOSVALR0                                   */
     /*                                                               */
     /*  (c) Finastra International Limited 2021                      */
     /*                                                               */
     /*  Last Amend No. EML113   *Create   Date 01Mar21               */
     /*                                                               */
     /*---------------------------------------------------------------*/
     /*                                                               */
     /*  EML113 - Re-set of Customer Exchange Reference Sequence      */
     /*           Number                                              */
     /*                                                               */
     /*****************************************************************/
/**/                                                                                      /*EML113*/
/* Check if the current setting of 'Re-set of Customer Exchange Reference    */           /*EML113*/
/* Sequence Number is 'Y'.                                                   */           /*EML113*/
/**/                                                                                      /*EML113*/
             CALL       PGM(AOSVALR0) PARM(&PRTCD &POP01 &PVL01 +
                          &POP02 &PVL02 &POP03 &PVL03 &POP04 &PVL04 +
                          &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
                          &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10)                      /*EML113*/
             IF         COND(((&PRTCD *EQ '       ') *AND   +
                        (&PVL01 *EQ 'Y')) *OR +
                        (&PRTCD *NE '       '))     THEN(DO)                              /*EML113*/
                                                                                          /*EML113*/
     /*****************************************************************/
     /*  End of /COPY EML113_002                                      */
     /*****************************************************************/
