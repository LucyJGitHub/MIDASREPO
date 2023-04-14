/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 to FBM2.1SP21                           */
/*   UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19                */
/*                                                                   */
/*********************************************************************/
/*********                                                           */                   /*EML108*/
/*********   CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'FMD003' +*/                   /*EML108*/
/*********                &DSFDY)                                    */            /*FMD003 EML108*/
/*********   IF         COND(&RTCD *EQ ' ') THEN(CHGVAR VAR(&FMD003) +/                   /*EML108*/
/*********                VALUE('Y'))                                */            /*FMD003 EML108*/
/*********   IF         COND(&FMD003 *EQ 'Y' *AND &MCTYP *EQ 'A' +   */                   /*EML108*/
/*********                *AND &MCTRM2 *EQ ' ' *AND &MCRPNC *EQ +    */                   /*EML108*/
/*********                '0000') THEN(CHGVAR VAR(&ABTYP) +          */                   /*EML108*/
/*********                VALUE('Y'))                                */            /*FMD003 EML108*/
/*********   IF         COND(&FMD003 *EQ 'Y' *AND &MCTRM1 *EQ 'D') + */                   /*EML108*/
/*********                THEN(CHGVAR VAR(&DBTYP) VALUE('Y'))        */            /*FMD003 EML108*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'EML108' +
                          &DSFDY)                                                         /*EML108*/
             IF         COND(&RTCD *EQ ' ') THEN(CHGVAR VAR(&EML108) +
                          VALUE('Y'))                                                     /*EML108*/
             IF         COND(&EML108 *EQ 'Y' *AND &MCTYP *EQ 'A' +
                          *AND &MCTRM2 *EQ ' ' *AND &MCRPNC *EQ +
                          '0000') THEN(CHGVAR VAR(&ABTYP) +
                          VALUE('Y'))                                                     /*EML108*/
             IF         COND(&EML108 *EQ 'Y' *AND &MCTRM1 *EQ 'D') +
                          THEN(CHGVAR VAR(&DBTYP) VALUE('Y'))                             /*EML108*/
                                                                                          /*EML108*/
