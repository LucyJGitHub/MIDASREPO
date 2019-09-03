/*********************************************************************/                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       Midas - /COPY NCI103_014                                    */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       RPC1045 - SNDMSG                                            */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       Last Amend No. NCI103  *Create    Date 18Jul19              */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       NCI103 - Replication enhancements (Upgrade to FM2.1 SP20)   */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
             IF         COND(&NCI103 *EQ 'Y') THEN(DO) /*NCI103*/
                SNDMSG     MSG('Job terminated - RPC1045 Midas Replication - End +
                             Feeder and Trigger - COB - Ended in Error') +
                             TOMSGQ(MOPERQ MRUNQ) /*NCI103*/
             MONMSG     MSGID(CPF0000)                                                    /*NCI103*/
             ENDDO                                                                        /*NCI103*/
             ELSE       CMD(DO)                                                           /*NCI103*/
/*********************************************************************/                   /*NCI103*/
/*  End of /COPY NCI103_014                                          */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
