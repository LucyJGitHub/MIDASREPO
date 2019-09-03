/*********************************************************************/                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       Midas - /COPY NCI103_025                                    */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       RPC5010 - Call AOSARDR0                                     */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       Last Amend No. NCI103  *Create    Date 18Jul19              */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       NCI103 - Replication enhancements (Upgrade to FM2.1 SP20)   */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
                                                                                          /*NCI103*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) /*NCI103*/
             IF         COND(&RTCD *EQ '       ') THEN(DO) /*NCI103*/
                CHGVAR     VAR(&NCI103) VALUE('Y') /*NCI103*/
             ENDDO      /*NCI103*/
                                                                                          /*NCI103*/
             IF         COND(&NCI103 *EQ 'Y') THEN(DO) /*NCI103*/
                SNDPGMMSG  MSG('RPC5010 Midas-STPayment Interface - Start Trigger +
                             Monitor') TOMSGQ(MRUNQ) MSGTYPE(*INFO) /*NCI103*/
             ENDDO                                                                        /*NCI103*/
             ELSE       CMD(DO) /*NCI103*/
                                                                                          /*NCI103*/
/*********************************************************************/                   /*NCI103*/
/*  End of /COPY NCI103_025                                          */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
