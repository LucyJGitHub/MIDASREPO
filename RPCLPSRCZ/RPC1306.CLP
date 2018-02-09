/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB define queues and channels')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1306 - Define MQM queues and channels.                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Function : this CLP program defines MQM queues and channels */
/*                  to receive messages from PC site and to send     */
/*                  confirmation messages to the PC.                 */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PC_Id &Replace)
 
/*-------------------------------------------------------------------*/
/*  Paramaters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&PC_Id)      TYPE(*CHAR) LEN(4)
                 /* PC identification code. */
             DCL        VAR(&Replace)    TYPE(*CHAR) LEN(4)
                 /* Replace MQM objects. */
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Sbs)        TYPE(*CHAR) LEN(2)
                 /* Midas subsystem id. */
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(512) +
                 /* Message text or data. */
 
             DCL        VAR(&QName)      TYPE(*CHAR) LEN(48) +
                 /* MQM Queue Name.  */
 
             DCL        VAR(&LName)      TYPE(*CHAR) LEN(8) +
                 /* Default Local Location */
 
             DCL        VAR(&Keyvar)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&key)        TYPE(*dec)  LEN(5 0)
             DCL        VAR(&Msgkey)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&Msgid)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&Msgf)       TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&Qryslt)     TYPE(*CHAR) LEN(128) +
                 /* Query selection expression. */
 
             DCL        VAR(&ChlName)    TYPE(*CHAR) LEN(20) +
                 /* Name of channel to be defined.  */
             DCL        VAR(&Text)       TYPE(*CHAR) LEN(64) +
                 /* Text description. */
             DCL        VAR(&TrmQName)   TYPE(*CHAR) LEN(48) +
                 /* MQM transmission queue name.  */
             DCL        VAR(&PrcName)    TYPE(*CHAR) LEN(48) +
                 /* MQM process name.  */
             DCL        VAR(&InitQName)    TYPE(*CHAR) LEN(48) +
                 /* MQM initiation queue name. */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  AS400/PCs connections file.                                      */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(RPCONNL2)
 
             RTVNETA    LCLLOCNAME(&LName)
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Send running program message.                                    */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Msgdta) VALUE('RPCSETMQMO - Define MQM +
                          objects for all hosts to receive messages +
                          from TOF and send back confirmation messages')
/**********  IF COND(&PC_Id *= '*ALL') THEN(DO)                      */ /*BG18886*/
             IF COND(&PC_Id *NE '*ALL') THEN(DO)                        /*BG18886*/
                   CHGVAR     VAR(%SST(&Msgdta 37 9)) +
                                VALUE('host' *BCAT &PC_Id *TCAT ' ')
             ENDDO
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Get Midas System Id.                                             */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
 
/*-------------------------------------------------------------------*/
/*  Connect to Message Queue Manager.                                */
/*  The Connect Message Queue Manager (CCTMQM) command is used to    */
/*  connect to the Message Queue Manager before issuing other MQM    */
/*  commands.                                                        */
/*                                                                   */
/*  The use of the CCTMQM command is optional, however, it can       */
/*  provide significant performance improvement when issuing a       */
/*  sequence of two or more MQM commands from either the command     */
/*  line or from a CL program.                                       */
/*                                                                   */
/*  Note:  This command has no effect on channel commands.           */
/*-------------------------------------------------------------------*/
 
             CCTMQM
 
/*-------------------------------------------------------------------*/
/*  Define local queue for messages coming from PC site.             */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&QName)    VALUE('MIDAS' *CAT &Sbs +
                                              *CAT '.TRANSACT.Q')
 
             CRTMQMQ    QNAME(&QName)          /* Queue name.                      */+
                          QTYPE(*LCL)          /* Queue type.                      */+
                          REPLACE(&Replace)    /* Replace.                         */+
                          TEXT(&Text)          /* Text description                 */+
                          PUTENBL(*YES)        /* Put enabled.                     */+
                          DFTPTY(1)            /* Default message priority         */+
                          DFTMSGPST(*YES)      /* Default message persistence      */+
                          PRCNAME(' ')         /* Process name.                    */+
                          TRGENBL(*NO)         /* Triggering enabled.              */+
                          GETENBL(*YES)        /* Get enabled.                     /*+
                          SHARE(*YES)          /* Sharing enabled.                 /*+
                          DFTSHARE(*YES)       /* Default share option.            /*+
                          MSGDLYSEQ(*PTY)      /* Message delivery sequence        /*+
                          HDNBKTCNT(*NO)       /* Harden backout count             /*+
                          TRGTYPE(*FIRST)      /* Trigger type                     /*+
                          TRGDEPTH(1)          /* Trigger depth                    /*+
                          TRGMSGPTY(0)         /* Trigger message priority         /*+
                          TRGDATA(' ')         /* Trigger data                     /*+
                          RTNITV(999999999)    /* Retention interval               /*+
                          MAXDEPTH(640000)     /* Maximum queue depth              /*+
                          MAXMSGLEN(4194304)   /* Maximum message length           /*+
                          BKTTHLD(0)           /* Backout threshold                /*+
                          BKTQNAME(' ')        /* Backout requeue queue            /*+
                          INITQNAME(' ')       /* Initiation queue                 /*+
                          USAGE(*NORMAL)       /* Usage                            /*+
                          DFNTYPE(*SYSDFTQ)    /* Definition type                  /*+
                          TGTQNAME(*SYSDFTQ)   /* Target queue                     /*+
                          RMTQNAME(*SYSDFTQ)   /* Remote queue name.               /*+
                          RMTMQMNAME(*SYSDFTQ) /* Remote QM Name.                  /*+
                          TMQNAME(*SYSDFTQ)    /* Transmission queue name.         */+
                          HIGHTHLD(80)         /* Queue depth high threshold.      */+
                          LOWTHLD(20)          /* Queue depth low threshold.       */+
                          FULLEVT(*YES)        /* Queue full events enabled.       */+
                          HIGHEVT(*NO)         /* Queue high events enabled.       */+
                          LOWEVT(*NO)          /* Queue low events enabled.        */+
                          SRVITV(999999999)    /* Service interval.                */+
                          SRVEVT(*NONE)        /* Service interval events.         */
 
 
/*-------------------------------------------------------------------*/
/*  Error found on CRTMQMQ command.                                  */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*No) KEYVAR(&Keyvar)
                   CHGVAR     VAR(&Key) VALUE(%BINARY(&Keyvar))
                   CHGVAR     VAR(&Key) VALUE(&Key - 1)
                   CHGVAR     VAR(%BIN(&msgkey)) VALUE(&Key)
                   RCVMSG     MSGTYPE(*ANY) MSGKEY(&Msgkey) RMV(*NO) +
                                MSGDTA(&Msgdta) MSGID(&Msgid) MSGF(&Msgf)
 
/*-------------------------------------------------------------------*/
/*  The queue already exists.                                        */
/*-------------------------------------------------------------------*/
 
                   IF         COND(&Msgid = 'AMQ8150') THEN(DO)
                         CHGVAR     VAR(&Msgdta) VALUE('  MQM queue' *BCAT +
                                      &QName *TCAT ' could not be created +
                                      because it already exists')
                         SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                      TOMSGQ(MRUNQ)
                         GOTO       CMDLBL(REMOTE)
                   ENDDO
 
/*-------------------------------------------------------------------*/
/*  An error occurred while defining the queue.                      */
/*-------------------------------------------------------------------*/
 
                   RMVMSG     MSGKEY(&Msgkey)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(REMOTE)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  MQM Queue was created.                                           */
/*-------------------------------------------------------------------*/
 
             RCVMSG     MSGTYPE(*LAST) RMV(*YES) MSGDTA(&Msgdta)
             CHGVAR     VAR(&Msgdta) VALUE('  MQM queue' *BCAT +
                          &QName *TCAT ' was created in library' +
                          *BCAT %SST(&Msgdta 21 10))
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Retrieve connection informations.                                */
/*-------------------------------------------------------------------*/
 
REMOTE:      IF COND(&PC_Id *EQ '*ALL') THEN(GOTO CMDLBL(RCVF))
             IF COND(%SST(&PC_Id 2 1) *EQ '*') THEN(DO)
                   CHGVAR     VAR(&Qryslt) VALUE('CNHSTI *EQ %WLDCRD(''' *CAT +
                                                  %SST(&PC_Id 1 1) *CAT '_'')')
             ENDDO
             ELSE       CMD(DO)
                   CHGVAR     VAR(&Qryslt) VALUE('(CNHSTI *EQ ''' *CAT +
                                                  &PC_id *CAT ''')')
             ENDDO
             OPNQRYF FILE((RPCONNL2)) QRYSLT(&qryslt)
 
RCVF:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
/*-------------------------------------------------------------------*/
/*  Send running program message.                                    */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Msgdta) VALUE('         *** Define MQM +
                          objects for host "' *CAT &CNHSTI *TCAT '" ***')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Define receiver channel for messages coming from PC site.        */
/*-------------------------------------------------------------------*/
 
RCVCHL:
             CHGVAR     VAR(&ChlName)  VALUE(&CNHSTI *CAT '.TO.' *CAT &LName)
             CHGVAR     VAR(&Text)     VALUE('Receiver channel for TOF messages +
                                              coming from' *BCAT &CNQMGR)
 
             CRTMQMCHL  CHLNAME(&ChlName)       /* Channel name.                   */+
                          CHLTYPE(*RCVR)        /* Channel type.                   */+
                          REPLACE(&Replace)     /* Replace.                        */+
                          TRPTYPE(*TCP)         /* Transport type.                 */+
                          TEXT(&Text)           /* Text description.               */+
                          MCAUSRID(*NONE)       /* Message channel agent user ID.  */+
                          BATCHSIZE(50)         /* Batch size.                     */+
                          SCYEXIT(*NONE)        /* Security exit.                  */+
                          SCYUSRDATA(' ')       /* Security exit user data.        */+
                          SNDEXIT(*NONE)        /* Send exit.                      */+
                          SNDUSRDATA(' ')       /* Send exit user data.            */+
                          RCVEXIT(*NONE)        /* Receive exit.                   */+
                          RCVUSRDATA(' ')       /* Receive exit user data.         */+
                          MSGEXIT(*NONE)        /* Message exit.                   */+
                          MSGUSRDATA(' ')       /* Message exit user data.         */+
                          MSGRTYEXIT(*NONE)     /* Message retry exit.             */+
                          MSGRTYDATA(' ')       /* Message retry exit data.        */+
                          MSGRTYNBR(10)         /* Number of message retries.      */+
                          MSGRTYITV(1000)       /* Message retry interval.         */+
                          PUTAUT(*DFT)          /* Put authority.                  */+
                          SEQNUMWRAP(999999999) /* Sequence number wrap.           */+
                          MAXMSGLEN(4194304)    /* Maximum message length.         */
 
/*-------------------------------------------------------------------*/
/*  Error found on CRTMQMCHL command.                                */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*NO) KEYVAR(&Msgkey)
                   RCVMSG     MSGTYPE(*PRV) MSGKEY(&Msgkey) RMV(*NO) +
                                KEYVAR(&Msgkey) MSGDTA(&Msgdta) +
                                MSGID(&Msgid) MSGF(&Msgf)
 
/*-------------------------------------------------------------------*/
/*  The channel already exists.                                      */
/*-------------------------------------------------------------------*/
 
                   IF         COND(&Msgid = 'AMQ8226') THEN(DO)
                         CHGVAR     VAR(&Msgdta) VALUE('  MQM channel' *BCAT +
                                      &ChlName *TCAT ' could not be created +
                                      because it already exists')
                         SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                      TOMSGQ(MRUNQ)
                        GOTO CMDLBL(RPYTRMQ)
                   ENDDO
 
/*-------------------------------------------------------------------*/
/*  An error occurred while creating the channel.                    */
/*-------------------------------------------------------------------*/
 
                   RMVMSG     MSGKEY(&Msgkey)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   GOTO CMDLBL(RPYTRMQ)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  MQM Channel was created.                                         */
/*-------------------------------------------------------------------*/
 
             RCVMSG     MSGTYPE(*LAST) RMV(*YES) MSGDTA(&Msgdta)
             CHGVAR     VAR(&MSGDTA) VALUE('  MQM channel' *BCAT +
                          &CHLNAME *TCAT ' was created')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Define reply transmission queue.                                 */
/*-------------------------------------------------------------------*/
 
RPYTRMQ:
             CHGVAR     VAR(&QName)     VALUE(&CNHSTI *CAT '.XMIT.Q')
             CHGVAR     VAR(&Text)      VALUE('Transmission queue for reply +
                                               messages from MIDAS' *CAT &Sbs *TCAT +
                                               ' to' *BCAT &CNQMGR *TCAT '.')
             CHGVAR     VAR(&ChlName)   VALUE(&LName *TCAT '.TO.' *CAT &CNHSTI)
             CHGVAR     VAR(&PrcName)   VALUE('START.CHANNEL.' *CAT &ChlName +
                                               *TCAT '.PROCESS')
             CHGVAR     VAR(&InitQName) VALUE('SYSTEM.CHANNEL.INITQ')
 
             CRTMQMQ    QNAME(&QName)          /* Queue name.                      */+
                          QTYPE(*LCL)          /* Queue type.                      */+
                          USAGE(*TMQ)          /* Usage                            /*+
                          REPLACE(&Replace)    /* Replace.                         */+
                          TEXT(&Text)          /* Text description                 */+
                          PUTENBL(*YES)        /* Put enabled.                     */+
                          DFTPTY(1)            /* Default message priority         */+
                          DFTMSGPST(*NO)       /* Default message persistence      */+
                          PRCNAME(&PrcName)    /* Process name.                    */+
                          TRGENBL(*YES)        /* Triggering enabled.              */+
                          GETENBL(*YES)        /* Get enabled.                     /*+
                          SHARE(*YES)          /* Sharing enabled.                 /*+
                          DFTSHARE(*NO)        /* Default share option.            /*+
                          MSGDLYSEQ(*PTY)      /* Message delivery sequence        /*+
                          HDNBKTCNT(*NO)       /* Harden backout count             /*+
                          TRGTYPE(*FIRST)      /* Trigger type                     /*+
                          TRGDEPTH(1)          /* Trigger depth                    /*+
                          TRGMSGPTY(0)         /* Trigger message priority         /*+
                          TRGDATA(' ')         /* Trigger data                     /*+
                          RTNITV(999999999)    /* Retention interval               /*+
                          MAXDEPTH(5000)       /* Maximum queue depth              /*+
                          MAXMSGLEN(4194304)   /* Maximum message length           /*+
                          BKTTHLD(0)           /* Backout threshold                /*+
                          BKTQNAME(' ')        /* Backout requeue queue            /*+
                          DFNTYPE(*SYSDFTQ)    /* Definition type                  /*+
                          TGTQNAME(*SYSDFTQ)   /* Target queue                     /*+
                          RMTQNAME(*SYSDFTQ)   /* Remote queue name.               /*+
                          RMTMQMNAME(*SYSDFTQ) /* Remote QM Name.                  /*+
                          TMQNAME(*SYSDFTQ)    /* Transmission queue name.         */+
                          HIGHTHLD(80)         /* Queue depth high threshold.      */+
                          LOWTHLD(20)          /* Queue depth low threshold.       */+
                          FULLEVT(*YES)        /* Queue full events enabled.       */+
                          HIGHEVT(*YES)        /* Queue high events enabled.       */+
                          LOWEVT(*YES)         /* Queue low events enabled.        */+
                          SRVITV(999999999)    /* Service interval.                */+
                          INITQNAME(&InitQName)/* Initiation queue                 /*+
                          SRVEVT(*NONE)        /* Service interval events.         */
 
/*-------------------------------------------------------------------*/
/*  Error found on CRTMQMQ command.                                  */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*No) KEYVAR(&Keyvar)
                   CHGVAR     VAR(&Key) VALUE(%BINARY(&Keyvar))
                   CHGVAR     VAR(&KEY) VALUE(&KEY - 1)
                   CHGVAR     VAR(%BIN(&msgkey)) VALUE(&KEY)
                   RCVMSG     MSGTYPE(*ANY) MSGKEY(&Msgkey) RMV(*NO) +
                                MSGDTA(&Msgdta) MSGID(&Msgid)
 
/*-------------------------------------------------------------------*/
/*  The queue already exists.                                        */
/*-------------------------------------------------------------------*/
 
                   IF         COND(&MSGID = 'AMQ8150') THEN(DO)
                         CHGVAR     VAR(&MSGDTA) VALUE('  MQM queue' *BCAT +
                                      &QName *TCAT ' could not be created +
                                      because it already exists')
                         SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                      TOMSGQ(MRUNQ)
                         GOTO       CMDLBL(RPYRMTQ)
                   ENDDO
 
/*-------------------------------------------------------------------*/
/*  An error occurred while defining the queue.                      */
/*-------------------------------------------------------------------*/
 
                   RMVMSG     MSGKEY(&Msgkey)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(RPYRMTQ)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  MQM Queue was created.                                           */
/*-------------------------------------------------------------------*/
 
             RCVMSG     MSGTYPE(*LAST) RMV(*YES) MSGDTA(&Msgdta)
             CHGVAR     VAR(&MSGDTA) VALUE('  MQM queue' *BCAT +
                          &QName *TCAT ' was created in library' +
                          *BCAT %SST(&Msgdta 21 10))
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Define reply remote queue.                                       */
/*-------------------------------------------------------------------*/
 
RPYRMTQ:
             CHGVAR     VAR(&TrmQName)  VALUE(&QName)
             CHGVAR     VAR(&QName)     VALUE(&CNHSTI *CAT '.REPLY.Q')
             CHGVAR     VAR(&Text)      VALUE('Remote queue for reply +
                                               messages from MIDAS' *CAT &Sbs *TCAT +
                                               ' to' *BCAT &CNQMGR *TCAT '.')
 
             CRTMQMQ    QNAME(&QName)          /* Queue name.                      */+
                          QTYPE(*RMT)          /* Queue type.                      */+
                          TMQNAME(&TrmQName)   /* Transmission queue name.         */+
                          RMTMQMNAME(&CNQMGR)  /* Remote QM Name.                  /*+
                          REPLACE(&Replace)    /* Replace.                         */+
                          TEXT(&Text)          /* Text description                 */+
                          PUTENBL(*YES)        /* Put enabled.                     */+
                          DFTPTY(1)            /* Default message priority         */+
                          DFTMSGPST(*YES)      /* Default message persistence      */+
                          RMTQNAME(&QName)     /* Remote queue name.               /*+
                          HIGHTHLD(*SYSDFTQ)   /* Queue depth high threshold.      */+
                          LOWTHLD(*SYSDFTQ)    /* Queue depth low threshold.       */+
                          FULLEVT(*SYSDFTQ)    /* Queue full events enabled.       */+
                          HIGHEVT(*SYSDFTQ)    /* Queue high events enabled.       */+
                          LOWEVT(*SYSDFTQ)     /* Queue low events enabled.        */+
                          SRVITV(*SYSDFTQ)     /* Service interval.                */+
                          SRVEVT(*SYSDFTQ)     /* Service interval events.         */
 
/*-------------------------------------------------------------------*/
/*  Error found on CRTMQMQ command.                                  */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*No) KEYVAR(&Keyvar)
                   CHGVAR     VAR(&Key) VALUE(%BINARY(&Keyvar))
                   CHGVAR     VAR(&Key) VALUE(&Key - 1)
                   CHGVAR     VAR(%BIN(&msgkey)) VALUE(&Key)
                   RCVMSG     MSGTYPE(*ANY) MSGKEY(&Msgkey) RMV(*NO) +
                                MSGDTA(&Msgdta) MSGID(&Msgid) MSGF(&Msgf)
 
/*-------------------------------------------------------------------*/
/*  The queue already exists.                                        */
/*-------------------------------------------------------------------*/
 
                   IF         COND(&MSGID = 'AMQ8150') THEN(DO)
                         CHGVAR     VAR(&Msgdta) VALUE('  MQM queue' *BCAT +
                                      &QName *TCAT ' could not be created +
                                      because it already exists')
                         SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                      TOMSGQ(MRUNQ)
                         GOTO       CMDLBL(SNDCHL)
                   ENDDO
 
/*-------------------------------------------------------------------*/
/*  An error occurred while defining the queue.                      */
/*-------------------------------------------------------------------*/
 
                   RMVMSG     MSGKEY(&Msgkey)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(SNDCHL)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  MQM Queue was created.                                           */
/*-------------------------------------------------------------------*/
 
             RCVMSG     MSGTYPE(*LAST) RMV(*YES) MSGDTA(&Msgdta)
             CHGVAR     VAR(&Msgdta) VALUE('  MQM queue' *BCAT +
                          &QName *TCAT ' was created in library' +
                          *BCAT %SST(&Msgdta 21 10))
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Define sender channel for reply messages to be sent to PC site.  */
/*-------------------------------------------------------------------*/
 
SNDCHL:
             CHGVAR     VAR(&ChlName)  VALUE(&LName *TCAT '.TO.' *CAT &CNHSTI)
             CHGVAR     VAR(&Text)     VALUE('Sender channel for reply messages +
                                              to be sent to' *BCAT &CNQMGR)
 
             CRTMQMCHL  CHLNAME(&ChlName)       /* Channel name.                   */+
                          CHLTYPE(*SDR)         /* Channel type.                   */+
                          REPLACE(&Replace)     /* Replace.                        */+
                          TRPTYPE(*TCP)         /* Transport type.                 */+
                          TEXT(&Text)           /* Text description.               */+
                          CONNAME(&CNQMGR)      /* Connection name.                */+
                          TMQNAME(&TrmQName)    /* Transmission queue.             */+
                          MCANAME(*NONE)        /* Message channel agent.          */+
                          MCAUSRID(*NONE)       /* Message channel agent user ID.  */+
                          BATCHSIZE(50)         /* Batch size.                     */+
                          DSCITV(6000)          /* Disconnect interval             */+
                          SHORTTMR(60)          /* Short retry interval            */+
                          SHORTRTY(10)          /* Short retry count  .            */+
                          LONGTMR(1200)         /* Long retry interval             */+
                          LONGRTY(999999999)    /* Long retry count . .            */+
                          SCYEXIT(*NONE)        /* Security exit.                  */+
                          SCYUSRDATA(' ')       /* Security exit user data.        */+
                          SNDEXIT(*NONE)        /* Send exit.                      */+
                          SNDUSRDATA(' ')       /* Send exit user data.            */+
                          RCVEXIT(*NONE)        /* Receive exit.                   */+
                          RCVUSRDATA(' ')       /* Receive exit user data.         */+
                          MSGEXIT(*NONE)        /* Message exit.                   */+
                          MSGUSRDATA(' ')       /* Message exit user data.         */+
                          SEQNUMWRAP(999999999) /* Sequence number wrap.           */+
                          MAXMSGLEN(4194304)    /* Maximum message length.         */+
                          CVTMSG(*YES)          /* Convert message.                */
 
/*-------------------------------------------------------------------*/
/*  Error found on CRTMQMCHL command.                                */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*NO) KEYVAR(&Msgkey)
                   RCVMSG     MSGTYPE(*PRV) MSGKEY(&Msgkey) RMV(*NO) +
                                KEYVAR(&Msgkey) MSGDTA(&Msgdta) +
                                MSGID(&Msgid) MSGF(&Msgf)
 
/*-------------------------------------------------------------------*/
/*  The channel already exists.                                      */
/*-------------------------------------------------------------------*/
 
                   IF         COND(&Msgid = 'AMQ8226') THEN(DO)
                         CHGVAR     VAR(&Msgdta) VALUE('  MQM channel' *BCAT +
                                      &ChlName *TCAT ' could not be created +
                                      because it already exists')
                         SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                      TOMSGQ(MRUNQ)
                        GOTO CMDLBL(RCVF)
                   ENDDO
 
/*-------------------------------------------------------------------*/
/*  An error occurred while creating the channel.                    */
/*-------------------------------------------------------------------*/
 
                   RMVMSG     MSGKEY(&Msgkey)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   GOTO CMDLBL(RCVF)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  MQM Channel was created.                                         */
/*-------------------------------------------------------------------*/
 
             RCVMSG     MSGTYPE(*LAST) RMV(*YES) MSGDTA(&Msgdta)
             CHGVAR     VAR(&MSGDTA) VALUE('  MQM channel' *BCAT +
                          &CHLNAME *TCAT ' was created')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ)
 
             GOTO       CMDLBL(RCVF)
 
/*-------------------------------------------------------------------*/
/*  Disconnect from Message Queue Manager.                           */
/*-------------------------------------------------------------------*/
 
             DSCMQM
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) VALUE('RPCSETMQM - Define queues +
                          and channels to receive messages from TOF +
                          and send back confirmation messages +
                          - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CLOF       OPNID(RPCONNL2)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
