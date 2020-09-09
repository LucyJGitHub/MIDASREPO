/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 to FBM2.1SP21                           */
/*                                                                   */
/*********************************************************************/

             IF         COND(&EML108 *EQ 'Y') THEN(CALL +
                        PGM(XX0750) PARM(&RSEQ &RLEV &RENT &CCY +
                          &RSNO &RSLV &RPCD &EVCD &MCGRP &MCRPNC +
                          &MCTRM1 &MCTRM2 &MCTYP &MCANL))
             ELSE       CMD(DO)
