     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *******************************************************************
/*STD *  RPGBASEMOD                                                     *
/*EXI *  TEXT('Midas FT Update Payment Routes OP References')
      *******************************************************************
      *                                                                 *
      *  Midas - Funds Transfer Module                                  *
      *                                                                 *
      *  FTP0785 - Midas FT Update Payment Routes OP References         *
      *                                                                 *
      *  Function - This program will update the OP references on       *
      *             LF/FTMROTV2 by accessing incoming message data on   *
      *             LF/MEINFTL2.                                        *
      *                                                                 *
      *  Called By: FTCP0780 (FT Payment Routes List - Control)         *
      *                                                                 *
      *  (c) Misys International Banking Systems Ltd. 2004              *
      *                                                                 *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11                 *
      *                 EEE065  *CREATE    Date 17Jun2004               *
      *                                                                 *
      *-----------------------------------------------------------------*
      *                                                                 *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.        *
      *  EEE065 - FT Payment Routing                                    *
      *                                                                 *
      *******************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFTMROTV2  UF   E           K DISK
      * FT Payment Routes by OP Reference
      *
     FMEINFTL2  IF   E           K DISK
      * Incoming Message FT Data by Unique Ref./Part Number
      *
      *****************************************************************
      /EJECT
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D***/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for access programs, short DS
 
     D @RUN            S              1
     D ReturnCode      S              7
     D Option          S              7
 
     D #Pgm            S             10
 
     D/COPY MECPYSRC,SRERRD_ILE
      *  Copysource for error processing
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      * Read payment routes
     C                   Read      @MROTV2                                Lr
 
     C                   Dou       *Inlr = *on
 
     C     KINFT         Klist
     C                   Kfld                    MOMSGR
     C                   Kfld                    MOKPRT
 
      ** Retrieve message data
     C     KINFT         Chain     @INFTL2
 
      *  Set up OP reference  if generated
     C                   If        %Found and FTOPRF <> *Blanks
     C                   Eval      MOOPRF = FTOPRF
 
      *  Set up audit stamp
     C                   TIME                    TIME              6 0
      *
     C                   Eval      MOAJOB = ##JOB                               Job Name
     C                   Eval      MOAUSR = ##USR                               User
     C                   Eval      MOATIM = TIME                                Action Time
     C                   Eval      MOARDT = AGMRDT                              Action Date
     C                   Eval      MORDNB = AGRDNB                              Run Day No.
 
     C                   Update    @MROTV2
     C                   Endif
 
      * Read next payment route
     C                   Read      @MROTV2                                LR
 
     C                   Enddo
 
     C                   Return
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      #Pgm = 'FTP0785'
 
      ** Retrieve bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM      '*FIRST   '   Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        ReturnCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  #Pgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
 
      * Get Rundate
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
 
     C                   ENDSR
      *********************************************************************
      /EJECT
     C/COPY MECPYSRC,SRERRC_ILE
