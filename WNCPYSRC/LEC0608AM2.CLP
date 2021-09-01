/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. MD058100           Date 20May21              */
/*       Prev Amend No. LUC139             Date 22Apr21              */
/*                      UIT021             Date 26feb97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD058100 - Rollup of additional BoI onsite fixes at FbMidas */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - BOI Monthly Reporting (Italy)                      */
/*                                                                   */
/*********************************************************************/
                                                                      /*UIT021*/
/***  If feature is installed and no db error (U7, U8 = OFF).  ***/   /*UIT021*/
                                                                      /*UIT021*/
             IF         COND(&UIT021 *EQ 'Y') THEN(DO)                /*UIT021*/
                                                                      /*UIT021*/
                DLTOVR     FILE(IRAPOSPD)                             /*UIT021*/
                MONMSG     MSGID(CPF0000)                             /*UIT021*/
                                                                      /*UIT021*/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)        /*UIT021*/
                                                                      /*UIT021*/
                      RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)    /*UIT021*/
                      CHGVAR     VAR(&DMLIB) VALUE(&PRE *CAT 'DMLIB') /*UIT021*/
                                                                      /*UIT021*/
/***  Copy IRAPOSPD from working image.  ***/                         /*UIT021*/
                                                                      /*UIT021*/
                      CPYF       FROMFILE(QTEMP/IRAPOSPD) +
                                 TOFILE(&DMLIB/IRAPOSPD) MBROPT(*ADD) /*UIT021*/
                                                                      /*UIT021*/
                      DLTF       FILE(QTEMP/IRAPOSPD)                 /*UIT021*/
                                                                      /*UIT021*/
                   ENDDO                                              /*UIT021*/
             ENDDO                                                    /*UIT021*/
                                                                      /*UIT021*/
