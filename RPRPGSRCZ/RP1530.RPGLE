     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extraction Module for SDBRCHPD')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1530 - Midas RP PB Extraction Module for SDBRCHPD          *
      *                                                               *
      *  Function:  This module sends the branch codes and the branch *
      *             country location from Midas to TOF.               *
      *                                                               *
      *  Component of: RP1530 - Extract program for SDBRCHPD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * 81   82   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  RtvPos   - Retrieve position in Meridian message.            *
      *  *PSSR    - Program exception error routine                   *
      *  *INZSR   - Program Initialization routine.                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,Std_Dcl
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C/COPY RPCPYSRC,Mdn_Hd_DS
 
      ** Following /COPY is the declares for fields passed to the formatting
      ** routines
     C/COPY RPCPYSRC,RPFMTDCL
 
      ** Following /COPY is the procedure prototype for the Packed routine
     C/COPY RPCPYSRC,RPFMTPPP
 
      ** Following /COPY is the procedure prototype for the Signed routine
     C/COPY RPCPYSRC,RPFMTPPS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Arrays used to store Position and Length of each fields
     D ArrFld          S              6    Dim(100)
     D ArrPos          S              7  0 Dim(100)
     D ArrLen          S              4  0 Dim(100)
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
 
      ** Data Structure for access to Location Codes.
     D Sdlocn        E DS                  Extname(SDLOCNPD)
 
      ** First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      ** DS for Access Programs, Extend Data Structure
     D Dsldy         E DS                  Extname(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for Output Queue
      ** Output queue name.
     D OutQueue        S                   LIKE(MQSQueue)
 
      ** Parameter for RPC1305
      ** Script Name.
     D ScriptName      S             10A
      ** Image Name.
     D ImageName       S             32A
      ** Field Name.
     D FieldName       S             10A
      ** Field Type.
     D FieldType       S              1A
      ** Field Value.
     D FieldValue      S           9999A
      ** Field Position.
     D FieldPosition   S              7S 0
      ** Field Length
     D FieldLength     S              4S 0
 
      ** Parameter for access programs
      ** Return code.
     D P_RtCd          S              7A
      ** Option.
     D P_Optn          S              7A
      ** Location code.
     D P_Locn          S              3A
 
      ** Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      ** End Position.
     D EndPosition     S              7S 0
 
      ** Additional fields
     D W_BrchCtryRes   S              2A
 
      ** Composite Data
     D CompData        S                   LIKE(TransData)
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      ** Work field used for Location
     D W_Location      S              3A
 
      ** Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** Work field used as index for an array
     D X               S              3  0 INZ
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C     Start         TAG
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *INZSR is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      ** Enter the processing to read the additional files and produce a
      ** composite message here.
 
 
      **----------------- Start of Additionnal fields ---------------**
 
      **---------------- Start of Transaction Location --------------**
      **                         Country Code                        **
 
     C                   Z-ADD     1             X
     C     'A8LCCD'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_Location = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      ** Get Transaction Location code.
     C                   EVAL      P_Locn = W_Location
     C                   EXSR      GetBrcLc
     C                   MOVE      DVCNCD        W_BrchCtryRes
 
      **                  End of Transaction Location                 **
      **-----------------        Country Code        ----------------**
 
 
      **------------------ End of Additionnal fields ----------------**
 
      ** Change message Type from _After to _A
      ** Determine Image Type.
 
     C                   EVAL      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      ** If it is impossible to determine the image type, handle error.
 
     C     W_PosFin      IFEQ      0
     C     *LOCK         IN        Lda
     C                   EVAL      DBPgm  = PSProcName
     C                   EVAL      DBFile = 'MSG Type'
     C                   EVAL      DBase  = 01
     C                   EVAL      DBKey  = RAMSGTYPE
     C                   OUT       Lda
     C                   EVAL      ReturnCode = 'Image_Type'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
 
      ** Place the result in field CompData.
 
     C                   EVAL      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_BrchCtryRes
 
      ** Call a standard routine to actually send the message.
 
     C                   CALLB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      ** If error then perform any special processing and exit
 
     C                   IF        ReturnCode <> *Blanks
     C     *LOCK         IN        Lda
     C                   MOVE      'RPSNDMSG  '  DBPgm
     C                   OUT       Lda
     C                   EXSR      *PSSR
 
      ** If no error, commit the unit of work so that messages that have
      ** been got from a queue would be permanently deleted and put
      ** operations would be made permanent.
 
     C                   ELSE
     C                   COMMIT
 
     C                   ENDIF
 
 
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  RtvPos   - Retrieve position in Meridian message.            *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     RtvPos        BEGSR
 
     C                   CALL      'RPC1305'
     C                   PARM                    ScriptName
     C                   PARM      RAMSGTYPE     ImageName
     C                   PARM                    FieldName
     C                   PARM                    FieldType
     C                   PARM                    TransData
     C                   PARM      0             FieldPosition
     C                   PARM      0             FieldLength
     C                   PARM      *Blanks       FieldValue
     C                   PARM      *Blanks       ReturnCode
 
      ** If any error occurred while retrieving position, handle it.
 
     C     ReturnCode    IFNE      *Blanks
     C     *LOCK         IN        Lda
     C                   EVAL      DBPgm  = PSProcName
     C                   EVAL      DBFile = 'Call    '
     C                   EVAL      DBase  = 02
     C                   EVAL      DBKey  = 'RPC1305'
     C                   OUT       Lda
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   EVAL      X = X + 1
 
      ** If any error occurred while retrieving position, handle it.
 
     C                   IF        X > 100
     C     *LOCK         IN        Lda
     C                   EVAL      DBPgm  = PSProcName
     C                   EVAL      DBFile = 'Array   '
     C                   EVAL      DBase  = 03
     C                   EVAL      DBKey  = 'Index  '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ArrFld(X) = FieldName
     C                   EVAL      ArrPos(X) = FieldPosition
     C                   EVAL      ArrLen(X) = FieldLength
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetBrcLc - get country code.                                 *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     GetBrcLc      BEGSR
 
      ** Access to AO Location Codes, by using access object.
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *Blanks       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Locn
     C     Sdlocn        PARM      Sdlocn        Dsfdy
 
      ** If currency does not exist, handle database error.
 
     C     P_Rtcd        IFNE      *Blanks
     C     *LOCK         IN        Lda
     C                   EVAL      DBPgm  = PSProcName
     C                   EVAL      DBFile = 'SDLOCNPD'
     C                   EVAL      DBase  = 04
     C                   EVAL      DBKey  = P_Locn
     C                   OUT       Lda
     C                   EVAL      ReturnCode  = P_Rtcd
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     W_RunBefore   IFEQ      *Blanks
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
 
     C                   IF        CommitCtl = 'Y'
     C                   ROLBK
     C                   ENDIF
 
     C     *LOCK         IN        Lda
     C     DBPgm         IFEQ      *Blanks
     C                   EVAL      DBPgm  = PSProcName
     C                   OUT       Lda
     C                   ENDIF
 
     C                   MOVE      'Y'           W_RunBefore
     C                   DUMP
 
     C                   ENDIF
 
     C     ReturnCode    IFEQ      *Blanks
     C                   EVAL      ReturnCode = '*PSSR'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called at : program initialization time.                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** MQSeries queue to write to - this parameter IS used in this module
     C                   PARM                    OutQueue
 
      ** Merdian header
     C                   PARM                    MdnHeadDS
 
      ** Transaction Data
     C                   PARM                    TransData
 
      ** Commitment control flag
     C                   PARM                    CommitCtl
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Set up work fields for formatting that will not change if
      ** Replication formatting is required.
      **    - signs are not shown for Positive numbers.
      **    - get decimal separator from Replication data area RPDFTSDA.
 
     C                   IN        RPDftsDa
     C                   EVAL      fmDecSep   = RCDECSEP
     C                   EVAL      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   MOVE      fmDpLen       W_PosDebut
     C                   EVAL      fmShwPsSgn = 'N'
 
      ** Set up work fields that will not change if retrieve
      ** function is to be used.
 
     C                   EVAL      ScriptName = 'RP' + RATGTSYS
 
      ** Retrieve position and length of location code from SDBRCHPD message data.
 
     C                   EVAL      FieldName   = 'A8LCCD'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      ** Retrieve begin position of additionnal fields in Meridian message.
 
     C                   EVAL      FieldName   = '*END_IMAGE'
     C                   EVAL      FieldType   = *Blanks
     C                   EXSR      RtvPos
     C                   EVAL      EndPosition = FieldPosition - 1
 
     C                   ENDSR
      /EJECT
      *****************************************************************
**  Cpy@
(c) Misys International Banking Systems Ltd. 2004
